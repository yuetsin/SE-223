SET @A_LABEL = 'A';
SET @B_LABEL = 'B';
SELECT 
    dept_name,
    IF(a_course_count > 2,
        @A_LABEL,
        @B_LABEL) AS level,
    id AS s_id,
    name AS s_name,
    a_course_count AS a_num
FROM
    (SELECT 
        student.dept_name,
            student.name,
            student.id,
            a_course_count,
            c_course_count
    FROM
        (SELECT 
        student.id, COUNT(*) AS a_course_count
    FROM
        university.student, university.takes
    WHERE
        student.id = takes.ID
            AND (takes.grade = 'A ' OR takes.grade = 'A+')
    GROUP BY id) AS ACOUNT, (SELECT 
        student.id, COUNT(*) AS c_course_count
    FROM
        university.student, university.takes
    WHERE
        student.id = takes.ID
            AND (takes.grade = 'C ' OR takes.grade = 'C-')
    GROUP BY id) AS CCOUNT, UNIVERSITY.student
    WHERE
        student.id = ACOUNT.id
            AND student.id = CCOUNT.id
            AND a_course_count > 0
    ORDER BY id) AS RAW_T
ORDER BY dept_name, level, a_num