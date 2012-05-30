class Standing < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true
  has_many :results, class_name: "StandingTable"

  attr_reader :conn

  def update_results
    results_data = get_results(rateable)
    results_data.each.with_index do |result,index|
      row = results.find_by_team_id! result["team_id"]
      row.update_attributes! rank: (index+1),
                             shot: result["shot"] && result["shot"].to_i,
                             got: result["got"] && result["got"].to_i,
                             diff: result["diff"] && result["diff"].to_i,
                             points: result["points"] && result["points"].to_i,
                             matches: result["matches"].to_i
    end
  end

  def group
    rateable_type == "Cup" ? nil : rateable_id
  end

  def cup
    rateable_type == "Cup" ? rateable_id : rateable.cup.id
  end

  private

  def get_results(rateable)
    set_connection
    conn.exec_query(standings_query(rateable)).to_a
  end

  def set_connection
    @conn ||= ActiveRecord::Base.connection
  end

  # ordering is crucial for correct ranking
  def standings_query(args)
    order_by = "points DESC NULLS LAST, diff DESC NULLS LAST, shot DESC NULLS LAST, got ASC NULLS LAST"
    query= <<EOF
SELECT	team_id,
	sum(own_score)		AS	shot,
	sum(other_score)	AS	got,
	sum(own_score) - sum(other_score)	AS	diff,
	sum(	CASE	WHEN	own_score > other_score	THEN	3
			WHEN	own_score < other_score	THEN	0
			WHEN	own_score = other_score THEN 	1
			ELSE	0
		END)	AS points,
	sum(	CASE	WHEN	own_score IS NOT NULL	THEN	1
		ELSE	0
		END) 	AS matches
FROM
	(
	SELECT 	matches.id,
		mp.team_id,
		CASE	WHEN	mp.role = 0	THEN	matches.home_score
			ELSE	matches.guest_score
		END	AS	own_score,
		CASE	WHEN	mp.role = 1	THEN	matches.home_score
			ELSE	matches.guest_score
		END	AS	other_score,
		CASE	WHEN	mp.role = 0	THEN	mp.team_id
			ELSE	other.team_id
		END	AS	home_team_id,
		CASE	WHEN	mp.role = 0	THEN 	other.team_id
			ELSE	mp.team_id
		END	AS	guest_team_id,
		matches.home_score,
		matches.guest_score,
		mp.role
		
	FROM		matches
			LEFT OUTER JOIN	match_participations
			AS		mp
			ON		matches.id = mp.match_id
			INNER JOIN	match_participations
			AS		other
			ON		(mp.match_id = other.match_id AND mp.role <> other.role)

	WHERE	matches.stage_id	IN
		(
		SELECT	id
		FROM	stages
		WHERE	stages.cup_id = #{cup}	#{group && "AND	stages.id = #{group}"}
		)
	)
AS		results
GROUP BY	team_id
ORDER BY #{order_by}
EOF
  end
end
