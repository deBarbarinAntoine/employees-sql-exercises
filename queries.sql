# Requêtes d'interrogation simples.
#
# Effectuez les requêtes suivantes :
#
#     Afficher le numéro, le nom, le prénom, le genre et la date de naissance de chaque employé. ( emp_no, last_name, first_name, gender, birth_date )
SELECT last_name, first_name, gender, birth_date
FROM employees;

#     Trouver tous les employés dont le prénom est 'Troy'. ( emp_no, first_name, last_name, gender )
SELECT emp_no, first_name, last_name, gender
FROM employees
WHERE first_name = 'Troy';

#     Trouver tous les employés de sexe féminin ( * ).
SELECT *
FROM employees
WHERE gender = 'F';

#     Trouver tous les employés de sexe masculin nés après le 31 janvier 1965 ( * ) ?
SELECT *
FROM employees
WHERE gender = 'M' AND birth_date > DATE('1965-01-31');

#     Lister uniquement les titres des employés, sans que les valeurs apparaissent plusieurs fois. (title) ?
SELECT t.title AS 'title'
FROM titles t
         JOIN employees e on t.emp_no = e.emp_no
GROUP BY t.title;

#     Combien y a t'il de département ? ( nombreDep ) ?
SELECT COUNT(*) AS 'nombreDep'
FROM departments;

#     Qui a eu le salaire maximum de tous les temps, et quel est le montant de ce salaire ? (emp_no, maxSalary) ?
SELECT emp_no, salary AS 'maxSalary'
FROM salaries
ORDER BY salary DESC
LIMIT 1;

#     Quel est salaire moyen de l'employé numéro 287323 toute période confondue ? (emp_no, salaireMoy) ?
SELECT emp_no, AVG(salary) AS 'salaireMoy'
FROM salaries
WHERE emp_no = '287323';

#     Qui sont les employés dont le prénom fini par 'ard' (*) ?
SELECT *
FROM employees
WHERE first_name LIKE '%ard';

#     Combien de personnes dont le prénom est 'Richard' sont des femmes ?
SELECT COUNT(*)
FROM employees
WHERE first_name = 'Richard'
    AND gender = 'F';

#     Combien y a t'il de titre différents d'employés (nombreTitre) ?
SELECT COUNT(DISTINCT t.title) AS 'nombreTitre'
FROM titles t;

#     Dans combien de département différents a travaillé l'employé numéro 287323 (nombreDep) ?
SELECT COUNT(DISTINCT de.dept_no) AS 'nombreDep'
FROM dept_emp de
WHERE de.emp_no = '287323';

#     Quels sont les employés qui ont été embauchés en janvier 2000. (*) ? Les résultats doivent être ordonnés par date d'embauche chronologique
SELECT *
FROM employees
WHERE hire_date BETWEEN DATE('2000-01-01') AND DATE('2000-01-31')
ORDER BY hire_date ASC;

#     Quelle est la somme cumulée des salaires de toute la société (sommeSalaireTotale) ?
SELECT SUM(salary) AS 'sommeSalaireTotale'
FROM salaries;

#
# Requêtes avec jointures :
#
#     Quel était le titre de Danny Rando le 12 janvier 1990 ? (emp_no, first_name, last_name, title) ?
SELECT e.emp_no AS 'emp_no', e.first_name AS 'first_name', e.last_name AS 'last_name', t.title AS 'title'
FROM employees e
         JOIN titles t on e.emp_no = t.emp_no
WHERE e.first_name = 'Danny' AND e.last_name = 'Rando'
  AND DATE ('1990-01-12') BETWEEN t.from_date AND t.to_date;

#     Combien d'employés travaillaient dans le département 'Sales' le 1er Janvier 2000 (nbEmp) ?
SELECT COUNT(DISTINCT de.emp_no) AS 'nbEmp'
FROM departments d
JOIN employees.dept_emp de on d.dept_no = de.dept_no
WHERE DATE('2000-01-01') BETWEEN de.from_date AND de.to_date
    AND d.dept_name = 'Sales';

#     Quelle est la somme cumulée des salaires de tous les employés dont le prénom est Richard (emp_no, first_name, last_name, sommeSalaire) ?
SELECT e.emp_no AS 'emp_no', e.first_name AS 'first_name', e.last_name AS 'last_name', SUM(s.salary) AS 'sommeSalaire'
FROM salaries s
         JOIN employees e on s.emp_no = e.emp_no
WHERE e.first_name = 'Richard'
GROUP BY e.emp_no, e.first_name, e.last_name;

#
# Agrégation
#
#     Indiquer pour chaque prénom 'Richard', 'Leandro', 'Lena', le nombre de chaque genre (first_name, gender, nombre). Les résultats seront ordonnés par prénom décroissant et genre.
SELECT first_name, gender, COUNT(*) AS 'nombre'
FROM employees
WHERE first_name IN ('Richard', 'Leandro', 'Lena')
GROUP BY gender, first_name
ORDER BY first_name DESC,
         gender;

#     Quels sont les noms de familles qui apparaissent plus de 200 fois (last_name, nombre) ? Les résultats seront triés par leur nombre croissant et le nom de famille.
SELECT last_name, COUNT(*) AS nombre
FROM employees
GROUP BY last_name HAVING COUNT(*) > 200
ORDER BY nombre ASC,
         last_name ASC;

#     Qui sont les employés dont le prénom est Richard qui ont gagné en somme cumulée plus de 1 000 000 (emp_no, first_name, last_name, hire_date, sommeSalaire) ?
SELECT e.emp_no, first_name, last_name, hire_date, SUM(s.salary) AS sommeSalaire
FROM employees e
         JOIN salaries s on e.emp_no = s.emp_no
WHERE first_name = 'Richard'
GROUP BY e.emp_no HAVING sommeSalaire > 1000000;

#     Quel est le numéro, nom, prénom de l'employé qui a eu le salaire maximum de tous les temps, et quel est le montant de ce salaire ? (emp_no, first_name, last_name, title, maxSalary)
SELECT e.emp_no, e.first_name, e.last_name, MAX(s.salary) AS maxSalary
FROM salaries s
JOIN employees e on e.emp_no = s.emp_no;

#     bonus. Qui est le manager de Martine Hambrick actuellement et quel est son titre (emp_no, first_name, last_name, title)


#
# La suite :
#
#     Quel est actuellement le salaire moyen de chaque titre (title, salaireMoyen) ? Classé par salaireMoyen croissant
#     Combien de manager différents ont eu les différents départements (dept_no, dept_name, nbManagers), Classé par nom de département
#     Quel est le département de la société qui a le salaire moyen le plus élevé (dept_no, dept_name, salaireMoyen)
#     Quels sont les employés qui ont eu le titre de 'Senior Staff' sans avoir le titre de 'Staff' ( emp_no , birth_date , first_name , last_name , gender , hire_date )
#     Indiquer le titre et le salaire de chaque employé lors de leur embauche (emp_no, first_name, last_name, title, salary)
#     Quels sont les employés dont le salaire a baissé (emp_no, first_name, last_name)
