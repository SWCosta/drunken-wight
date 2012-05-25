class Standing

  def self.all(args = {})
    new(args).results
  end

  attr_reader :results
  attr_accessor :stage

  def initialize(args)
    @args = args
    @stage = args[:stage_id]
    @results = get_results(args)
  end

  def get_results(args)
    if Stage::WITH_STANDINGS.include?(stage) || stage.nil?
      Match.find_by_sql(standings_query(args))
    else
      raise ArgumentError
    end
  end

  private

  def standings_query(args)
    args[:order_by] ||= "overall_points DESC NULLS LAST, diff DESC NULLS LAST"
    raise ArgumentError, ":order_by muss ein String sein" unless args[:order_by].is_a? String
    query= <<EOF
SELECT
  stage_id,
  country_id AS home_id,
	sum(own) as shot,
	sum(other) as got,
  sum(own) - sum(other) as diff,
	sum(points) as overall_points
FROM
	(
	SELECT 
	  id, stage_id, home_id as country_id, home_score as own, guest_score as other,
	  CASE WHEN home_score < guest_score THEN 0
	       WHEN home_score > guest_score THEN 3
	       WHEN home_score = guest_score THEN 1
	  END AS points
	  FROM matches
	  #{stage && "WHERE stage_id = #{stage}"}

	UNION

	SELECT 
	  id, stage_id, guest_id as country_id, guest_score as own, home_score as other,
	  CASE WHEN guest_score < home_score THEN 0
	       WHEN guest_score > home_score THEN 3
	       WHEN guest_score = home_score THEN 1
	  END AS points
	  FROM matches
	  #{stage && "WHERE stage_id = #{stage}"}
	)
	
AS results
GROUP BY country_id, stage_id
ORDER BY #{args[:order_by]}
EOF
  end

end
