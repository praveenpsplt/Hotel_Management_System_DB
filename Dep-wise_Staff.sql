SELECT
    d.department_name,
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    s.job_title,
    s.email
FROM departments d
LEFT JOIN staff s
    ON d.department_id = s.department_id
ORDER BY d.department_name;