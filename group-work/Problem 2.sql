DELIMITER ;;
DROP FUNCTION IF EXISTS teacher_salary;;

CREATE FUNCTION teacher_salary(dept_name VARCHAR(20))
RETURNS DECIMAL(8, 2)
READS SQL DATA
BEGIN
	DECLARE AVG DECIMAL(8, 2);
	SELECT SUM(salary) INTO AVG FROM instructor
    WHERE instructor.dept_name = dept_name;
    RETURN AVG;
END;;

SELECT 
    dept_name, teacher_salary(dept_name) as TOT_SALARY
FROM
    department
ORDER BY TOT_SALARY DESC;;