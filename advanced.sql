# 1. Exercice: Trouver les départements dont le salaire moyen est supérieur à celui de la moyenne de la société.
SELECT d.dept_name, AVG(s.salary) average
FROM departments d
         JOIN current_dept_emp de on d.dept_no = de.dept_no
         JOIN salaries s on de.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING average > (SELECT AVG(salary) FROM salaries
                  WHERE CURRENT_DATE BETWEEN from_date AND to_date);

-- CTE version
WITH CompanyAverage AS ( SELECT AVG(salary) average FROM salaries
                         WHERE CURRENT_DATE BETWEEN from_date AND to_date)
SELECT d.dept_name, AVG(s.salary) Dept_average
FROM departments d
         JOIN current_dept_emp de on d.dept_no = de.dept_no
         JOIN salaries s on de.emp_no = s.emp_no
WHERE CURRENT_DATE BETWEEN s.from_date AND s.to_date
GROUP BY d.dept_name
HAVING Dept_average > ( SELECT average FROM CompanyAverage);

# 2. Exercice: Réaliser la combinaison de l'ensemble des employés et des départements (ce qui n'a aucun sens, on est bien d'accord).
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, d.dept_name
FROM employees e
         CROSS JOIN departments d;

-- dumb combination
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, d.dept_name
FROM employees e, departments d;

# 3. Exercice: Trouver les employés qui n'appartiennent à aucun département.
SELECT e.emp_no, e.first_name, e.last_name
FROM employees e
WHERE e.emp_no NOT IN ( SELECT emp_no FROM current_dept_emp );

-- CTE version
WITH Emp_having_dept AS (
    SELECT emp_no
    FROM current_dept_emp
)
SELECT e.emp_no, e.first_name, e.last_name
FROM employees e
WHERE e.emp_no NOT IN ( SELECT emp_no FROM Emp_having_dept );

# 1. Exercice : Trouver les départements avec un salaire moyen supérieur à celui de l’entreprise
# Consigne : Utilisez une CTE pour calculer le salaire moyen de l’entreprise, puis filtrez les départements dont le salaire moyen est supérieur.
WITH CompanyAverage AS ( SELECT AVG(salary) average FROM salaries
                         WHERE CURRENT_DATE BETWEEN from_date AND to_date)
SELECT d.dept_name, AVG(s.salary) Dept_average
FROM departments d
         JOIN current_dept_emp de on d.dept_no = de.dept_no
         JOIN salaries s on de.emp_no = s.emp_no
WHERE CURRENT_DATE BETWEEN s.from_date AND s.to_date
GROUP BY d.dept_name
HAVING Dept_average > ( SELECT average FROM CompanyAverage);

# 2. Exercice : Calculer la liste des employés avec leur rang de salaire dans leur département
# Consigne : Utilisez une CTE pour associer un rang de salaire (RANK()) à chaque employé au sein de son département.
SELECT e.emp_no, e.first_name, e.last_name, s.salary, d.dept_name, RANK() OVER (ORDER BY s.salary)
FROM employees e
JOIN employees.dept_emp de on e.emp_no = de.emp_no
JOIN employees.departments d on d.dept_no = de.dept_no
JOIN employees.salaries s on e.emp_no = s.emp_no;

# 3. Exercice : Identifier les périodes où un employé a changé de département
# Consigne : Suivez les transitions d’un employé entre différents départements à l’aide d’une CTE.

