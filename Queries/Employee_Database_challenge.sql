-- Employee_Database_challenge.sql

-- DELIVERABLE 1:
-- retirement_titles table
SELECT e.emp_no, e.first_name, e.last_name, 
	t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
	ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- unique_titles table
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- retiring_titles table
SELECT COUNT(title) AS count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title 
ORDER BY count DESC;

-- DELIVERABLE 2:
-- mentorship_elegibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, 
	de.from_date, de.to_date, t.title
INTO mentorship_elegibility
FROM employees AS e
LEFT JOIN dept_emp AS de
	ON (e.emp_no=de.emp_no)
LEFT JOIN titles AS t
	ON (e.emp_no=t.emp_no)
WHERE (de.to_date = ('9999-01-01'))
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY (emp_no);

-- DELIVERABLE 3: (two additional queries)

-- Creating retirement titles table (retirement_titles_2)
SELECT e.emp_no, e.first_name, e.last_name, 
	t.title, t.from_date, t.to_date, 
	de.dept_no, 
	d.dept_name
INTO retirement_titles_2
FROM employees AS e
INNER JOIN titles AS t
	ON (e.emp_no=t.emp_no)
LEFT JOIN dept_emp AS de
	ON (e.emp_no=de.emp_no)
LEFT JOIN departments AS d
	ON (de.dept_no=d.dept_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- creating unique retirement titles by departments table (unique_titles_2)
SELECT emp_no,
first_name,
last_name,
title,
dept_name,
to_date
INTO unique_titles_2
FROM retirement_titles_2
WHERE to_date = ('9999-01-01')
ORDER BY emp_no;

-- creating retiring titles by departments table (retiring_titles_2)
SELECT dept_name AS "Department Name",
COUNT(emp_no) AS "Retiring Employee Count" 
INTO retiring_titles_2
FROM unique_titles_2
GROUP BY "Department Name"
ORDER BY "Retiring Employee Count" DESC;

-- How many roles will need to be filled as the "silver tsunami" begins to make an impact?
SELECT COUNT(emp_no) FROM unique_titles_2;

-- creating mentorship elegibility by department table (mentorship_elegibility_2)
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, 
	de.from_date, de.to_date, t.title, dep.dept_name
INTO mentorship_elegibility_2
FROM employees AS e
LEFT JOIN dept_emp AS de
	ON (e.emp_no=de.emp_no)
LEFT JOIN titles AS t
	ON (e.emp_no=t.emp_no)
LEFT JOIN departments AS dep
	ON (de.dept_no=dep.dept_no)
WHERE (de.to_date = ('9999-01-01'))
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY (emp_no);

-- creating mentoship titles by departments table (mentorship_titles)
SELECT dept_name AS "Department Name",
COUNT(emp_no) AS "Mentorship Elegible Count" 
INTO mentorship_elegible
FROM mentorship_elegibility_2
GROUP BY "Department Name"
ORDER BY "Mentorship Elegible Count" DESC;

--final table
SELECT rt."Department Name", rt."Retiring Employee Count",
me."Mentorship Elegible Count"
INTO final_table
FROM retiring_titles_2 as rt
LEFT JOIN mentorship_elegible AS me
ON (rt."Department Name"=me."Department Name");

-- Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
SELECT "Department Name", 
("Retiring Employee Count"/"Mentorship Elegible Count") AS Ratio
FROM final_table;
