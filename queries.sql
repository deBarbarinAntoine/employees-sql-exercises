# Requêtes d'interrogation simples.
#
# Effectuez les requêtes suivantes :
#
#     1. Afficher le numéro, le nom, le prénom, le genre et la date de naissance de chaque employé. ( emp_no, last_name, first_name, gender, birth_date )
SELECT last_name, first_name, gender, birth_date
FROM employees;

#     2. Trouver tous les employés dont le prénom est 'Troy'. ( emp_no, first_name, last_name, gender )
SELECT emp_no, first_name, last_name, gender
FROM employees
WHERE first_name = 'Troy';

#     3. Trouver tous les employés de sexe féminin ( * ).
SELECT *
FROM employees
WHERE gender = 'F';

#     4. Trouver tous les employés de sexe masculin nés après le 31 janvier 1965 ( * ) ?
SELECT *
FROM employees
WHERE gender = 'M' AND birth_date > DATE('1965-01-31');

#     5. Lister uniquement les titres des employés, sans que les valeurs apparaissent plusieurs fois. (title) ?
SELECT t.title
FROM titles t
         JOIN employees e on t.emp_no = e.emp_no
GROUP BY t.title;

-- correction:
SELECT DISTINCT title
FROM titles;

#     6. Combien y a t'il de département ? ( nombreDep ) ?
SELECT COUNT(*) nombreDep
FROM departments;

#     7. Qui a eu le salaire maximum de tous les temps, et quel est le montant de ce salaire ? (emp_no, maxSalary) ?
SELECT emp_no, salary maxSalary
FROM salaries
ORDER BY salary DESC
LIMIT 1;

-- correction:
SELECT emp_no, max(salary) maxSalary
FROM salaries;

#     8. Quel est salaire moyen de l'employé numéro 287323 toute période confondue ? (emp_no, salaireMoy) ?
SELECT emp_no, AVG(salary) salaireMoy
FROM salaries
WHERE emp_no = '287323';

#     9. Qui sont les employés dont le prénom fini par 'ard' (*) ?
SELECT *
FROM employees
WHERE first_name LIKE '%ard';

#     10. Combien de personnes dont le prénom est 'Richard' sont des femmes ?
SELECT COUNT(*)
FROM employees
WHERE first_name = 'Richard'
  AND gender = 'F';

#     11. Combien y a t'il de titre différents d'employés (nombreTitre) ?
SELECT COUNT(DISTINCT t.title) nombreTitre
FROM titles t;

#     12. Dans combien de département différents a travaillé l'employé numéro 287323 (nombreDep) ?
SELECT COUNT(DISTINCT de.dept_no) nombreDep
FROM dept_emp de
WHERE de.emp_no = '287323';

#     13. Quels sont les employés qui ont été embauchés en janvier 2000. (*) ? Les résultats doivent être ordonnés par date d'embauche chronologique
SELECT *
FROM employees
WHERE hire_date BETWEEN DATE('2000-01-01') AND DATE('2000-01-31')
ORDER BY hire_date;

#     14. Quelle est la somme cumulée des salaires de toute la société (sommeSalaireTotale) ?
SELECT SUM(salary) sommeSalaireTotale
FROM salaries;

#
# Requêtes avec jointures :
#
#     15. Quel était le titre de Danny Rando le 12 janvier 1990 ? (emp_no, first_name, last_name, title) ?
SELECT e.emp_no, e.first_name, e.last_name, t.title
FROM employees e
         JOIN titles t on e.emp_no = t.emp_no
WHERE e.first_name = 'Danny' AND e.last_name = 'Rando'
  AND DATE ('1990-01-12') BETWEEN t.from_date AND t.to_date;

#     16. Combien d'employés travaillaient dans le département 'Sales' le 1er Janvier 2000 (nbEmp) ?
SELECT COUNT(*) nbEmp
FROM departments d
         JOIN employees.dept_emp de on d.dept_no = de.dept_no
WHERE DATE('2000-01-01') BETWEEN de.from_date AND de.to_date
  AND d.dept_name = 'Sales';

#     17. Quelle est la somme cumulée des salaires de tous les employés dont le prénom est Richard (emp_no, first_name, last_name, sommeSalaire) ?
SELECT e.emp_no, e.first_name, e.last_name, SUM(s.salary) sommeSalaire
FROM salaries s
         JOIN employees e on s.emp_no = e.emp_no
WHERE e.first_name = 'Richard'
GROUP BY e.emp_no, e.first_name, e.last_name;

#
# Agrégation
#
#     18. Indiquer pour chaque prénom 'Richard', 'Leandro', 'Lena', le nombre de chaque genre (first_name, gender, nombre). Les résultats seront ordonnés par prénom décroissant et genre.
SELECT first_name, gender, COUNT(*) nombre
FROM employees
WHERE first_name IN ('Richard', 'Leandro', 'Lena')
GROUP BY gender, first_name
ORDER BY first_name DESC,
         gender;

#     19. Quels sont les noms de familles qui apparaissent plus de 200 fois (last_name, nombre) ? Les résultats seront triés par leur nombre croissant et le nom de famille.
SELECT last_name, COUNT(*) nombre
FROM employees
GROUP BY last_name HAVING COUNT(*) > 200
ORDER BY nombre, last_name;

#     20. Qui sont les employés dont le prénom est Richard qui ont gagné en somme cumulée plus de 1 000 000 (emp_no, first_name, last_name, hire_date, sommeSalaire) ?
SELECT e.emp_no, first_name, last_name, hire_date, SUM(s.salary) sommeSalaire
FROM employees e
         JOIN salaries s on e.emp_no = s.emp_no
WHERE first_name = 'Richard'
GROUP BY e.emp_no HAVING sommeSalaire > 1000000;

#     21. Quel est le numéro, nom, prénom de l'employé qui a eu le salaire maximum de tous les temps, et quel est le montant de ce salaire ? (emp_no, first_name, last_name, title, maxSalary)
SELECT e.emp_no, first_name, last_name,  salary AS maxSalary
FROM salaries s JOIN employees e ON e.emp_no = s.emp_no
WHERE salary = (SELECT max(salary) FROM salaries );

#     22. bonus. Qui est le manager de Martine Hambrick actuellement et quel est son titre (emp_no, first_name, last_name, title)
SELECT em.emp_no, em.first_name, em.last_name, t.title
FROM employees e
         JOIN dept_emp de on e.emp_no = de.emp_no
         JOIN employees.dept_manager dm on de.dept_no = dm.dept_no
         JOIN employees em on em.emp_no = dm.emp_no
         JOIN titles t on em.emp_no = t.emp_no
WHERE  e.first_name = 'Martine' AND e.last_name = 'Hambrick'
  AND NOW() BETWEEN dm.from_date AND dm.to_date
  AND NOW() BETWEEN t.from_date AND t.to_date;

#
# La suite :
#
#     23. Quel est actuellement le salaire moyen de chaque titre (title, salaireMoyen) ? Classé par salaireMoyen croissant
SELECT t.title, AVG(s.salary) salaireMoyen
FROM titles t
         JOIN employees e on t.emp_no = e.emp_no
         JOIN salaries s on e.emp_no = s.emp_no
WHERE now() BETWEEN t.from_date AND t.to_date AND now() BETWEEN s.from_date AND s.to_date
GROUP BY t.title
ORDER BY salaireMoyen;

#     24. Combien de manager différents ont eu les différents départements (dept_no, dept_name, nbManagers), Classé par nom de département
SELECT d.dept_no, d.dept_name, COUNT(dm.emp_no) nbManagers
FROM departments d
    JOIN employees.dept_manager dm on d.dept_no = dm.dept_no
GROUP BY d.dept_no, d.dept_name
ORDER BY d.dept_name;

#     25. Quel est le département de la société qui a le salaire moyen le plus élevé (dept_no, dept_name, salaireMoyen)
SELECT d.dept_no, d.dept_name, AVG(salary) AS salaireMoyen
FROM departments d INNER JOIN dept_emp de ON de.dept_no = d.dept_no INNER JOIN employees e ON e.emp_no = de.emp_no INNER JOIN salaries s ON s.emp_no = e.emp_no
WHERE CURRENT_DATE BETWEEN de.from_date AND de.to_date
GROUP BY d.dept_no, d.dept_name
HAVING AVG(salary) = (SELECT max(salaireMoyen)
                      FROM (
                               SELECT d.dept_no, d.dept_name, AVG(salary) AS salaireMoyen
                               FROM departments d INNER JOIN dept_emp de ON de.dept_no = d.dept_no INNER JOIN employees e ON e.emp_no = de.emp_no INNER JOIN salaries s ON s.emp_no = e.emp_no
                               WHERE CURRENT_DATE BETWEEN de.from_date AND de.to_date
                               GROUP BY d.dept_no, d.dept_name
                           ) AS salMoy
);
WITH salMoy as (
    SELECT d.dept_no, d.dept_name, AVG(salary) AS salaireMoyen
    FROM departments d INNER JOIN dept_emp de ON de.dept_no = d.dept_no INNER JOIN employees e ON e.emp_no = de.emp_no INNER JOIN salaries s ON s.emp_no = e.emp_no
    WHERE CURRENT_DATE BETWEEN de.from_date AND de.to_date
    GROUP BY d.dept_no, d.dept_name
)
SELECT d.dept_no, d.dept_name, salaireMoyen
from salMoy d
where salaireMoyen = (SELECT max(salaireMoyen)
                      FROM salMoy
);

#     26. Quels sont les employés qui ont eu le titre de 'Senior Staff' sans avoir le titre de 'Staff' ( emp_no , birth_date , first_name , last_name , gender , hire_date )
SELECT e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date
FROM employees e
         JOIN titles t on e.emp_no = t.emp_no
         LEFT JOIN (
    SELECT emp_no
    FROM titles t2
    WHERE t2.title = 'Staff') et2 on e.emp_no = et2.emp_no
WHERE t.title = 'Senior Staff'
  AND et2.emp_no IS NULL;

--

#     27. Indiquer le titre et le salaire de chaque employé lors de leur embauche (emp_no, first_name, last_name, title, salary)
SELECT e.emp_no, e.first_name, e.last_name, t.title, s.salary
FROM employees e
         JOIN (
    SELECT emp_no, MIN(from_date) first_title
    FROM titles
    GROUP BY emp_no) t1 ON e.emp_no = t1.emp_no
         JOIN titles t ON t1.emp_no = t.emp_no AND t1.first_title = t.from_date
         JOIN (
    SELECT emp_no, MIN(from_date) first_salary
    FROM salaries
    GROUP BY emp_no) s1 ON e.emp_no = s1.emp_no
         JOIN salaries s ON s1.emp_no = s.emp_no AND s1.first_salary = s.from_date;

-- correction
SELECT e.emp_no,  first_name, last_name, title, salary, t.from_date, s.from_date, hire_date
FROM employees e
         INNER JOIN  salaries s ON e.emp_no = s.emp_no
         INNER JOIN titles t ON t.emp_no = e.emp_no
WHERE s.from_date <= ALL (SELECT from_date FROM salaries s2 WHERE s2.emp_no = s.emp_no)
  AND t.from_date = s.from_date;

#     28. Quels sont les employés dont le salaire a baissé (emp_no, first_name, last_name)
SELECT e.emp_no, e.first_name, e.last_name
FROM employees e
         JOIN (
    SELECT emp_no, MIN(from_date) first_salary
    FROM salaries
    GROUP BY emp_no) s1 ON e.emp_no = s1.emp_no
         JOIN salaries fs ON s1.emp_no = fs.emp_no AND s1.first_salary = fs.from_date
         JOIN (
    SELECT emp_no, MAX(from_date) last_salary
    FROM salaries
    GROUP BY emp_no) s2 ON e.emp_no = s2.emp_no
         JOIN salaries ls ON s2.emp_no = ls.emp_no AND s2.last_salary = ls.from_date
WHERE fs.salary > ls.salary;

-- correction
SELECT e.emp_no, first_name, last_name
FROM employees e JOIN salaries s ON e.emp_no = s.emp_no
WHERE EXISTS (SELECT * FROM salaries s2 WHERE s.emp_no = s2.emp_no AND s2.from_date > s.from_date and s2.salary < s.salary );