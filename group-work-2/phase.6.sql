DROP FUNCTION IF EXISTS get_average_score;

CREATE FUNCTION get_average_score (
	check_username VARCHAR(50)
)
RETURNS DECIMAL(3, 2)
READS SQL DATA
BEGIN
	DECLARE AVG DECIMAL(3, 2);
	SELECT AVG(score)
	INTO AVG
	FROM score
	WHERE score.username = check_username;
	RETURN AVG;
END;
