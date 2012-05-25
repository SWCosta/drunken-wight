class Stage < ActiveRecord::Base
  has_many :matches
  has_many :teams
  has_one :cup, through: :matches

  def standings(*args)
    args.extract_options!
    Stage.find_by_sql(standings_query(args))
  end

  private

  def standings_query(args)
    query= <<EOF
SELECT
	country_id,
	sum(own) as shot,
	sum(other) as got,
	sum(points) as overall_points
FROM
	(
	SELECT 
	  id, home_id as country_id, home_score as own, guest_score as other,
	  CASE WHEN home_score < guest_score THEN 0
	       WHEN home_score > guest_score THEN 3
	       WHEN home_score = guest_score THEN 1
	  END AS points
	  FROM matches
	  WHERE stage_id = 1

	UNION

	SELECT 
	  id, guest_id as country_id, guest_score as own, home_score as other,
	  CASE WHEN guest_score < home_score THEN 0
	       WHEN guest_score > home_score THEN 3
	       WHEN guest_score = home_score THEN 1
	  END AS points
	  FROM matches
	  WHERE stage_id = 1
	)
	
AS results
GROUP BY country_id
ORDER BY overall_points DESC
EOF
  end

end
