class Standing

#  def inspect
#    to_a.inspect
#  end

# results for the whole cup
#  def self.all(args = {})
#    new(args).results
#  end

  attr_reader :results, :group, :cup
  #attr_accessor :group

  def initialize(args={})
    @group = args[:group_id]
    @cup = args[:cup_id] || Group.find(@group).stage.cup.id
    @results = get_results(args)
  end

  def get_results(args={})
    Match.find_by_sql(standings_query(args))
  end

  private

  def standings_query(args)
    args[:order_by] ||= "points DESC NULLS LAST, diff DESC NULLS LAST"
    raise ArgumentError, ":order_by muss ein String sein" unless args[:order_by].is_a? String
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
		END) 	AS games
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

	WHERE	mp.team_id	IN
		(
		SELECT	teams.id
		FROM	teams
	  #{group && "WHERE group_id = #{group}"}
		)
    AND matches.cup_id = #{cup}
	)
AS		results
GROUP BY	team_id
ORDER BY #{args[:order_by]}
EOF
  end

end
