DROP PROCEDURE IF EXISTS check_history_score;

CREATE PROCEDURE check_history_score (
	check_username VARCHAR(50)
)
BEGIN
	SELECT use_username, score, comment, img, `type`
	FROM score
	WHERE username = check_username;
END
