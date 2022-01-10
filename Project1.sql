''' Number 1: Show details of the highest paid employee. Display their first and last name, salary, job id, department name, city, and country name. Do not hard code any values in the WHERE clause.'''

Select emp.first_name as "first name", emp.last_name as "last name", emp.salary as "salary", emp.job_id as "job id", dep.department_id as "department ID", loc.city As "city", cou.country_name As "country"
From employees emp
LEFT JOIN departments dep
ON emp.department_id = dep.department_id
INNER JOIN locations loc
ON dep.location_id = loc.location_id
INNER JOIN countries cou
ON cou.country_id = loc.country_id
WHERE emp.job_id = 'AD_PRES' AND emp.salary > 18000
ORDER BY emp.salary DESC;

'''Number 2: Show any employee who still appears as a consultant. Display the first and last name, job id, salary, and manager id, all from the employees table. Sort the result by last name. '''

Select em.first_name AS "First Name", em.last_name AS "Last Name", em.job_id AS "JOB", em.salary AS "Salary", em.manager_id AS "Manager"
From employees em 
JOIN consultants con ON em.email = con.email
ORDER BY em.last_name;

'''Number 3: For every sale, show the sales id, the customer first and last names, the sales amount, and the first and last names of the sales representative.
Show all customers, even if they have no sales. For these customers, show the sales amount as 0. Sort the result by the sales id.  '''

Select sal.sales_id, NVL(sal.sales_amt, 0), sal.sales_amt, cust.cust_fname, cust.cust_lname, emp.first_name AS "Rep First Name", emp.last_name AS "Rep Last Name"
FROM employees emp 
JOIN sales sal ON emp.employee_id = sal.sales_rep_id 
RIGHT JOIN customers cust ON sal.sales_cust_id = cust.cust_id 
ORDER BY sal.sales_id;

''' Number 4: Show the managers who manage departments. Display the first and last names, department names, addresses, cities, and states. Sort the output by department id. '''

Select em.first_name, em.last_name, dep.department_name, loc.street_address, loc.city, loc.state_province 
FROM employees em 
INNER JOIN departments dep ON em.manager_id = dep.manager_id 
INNER JOIN locations loc ON dep.location_id = loc.location_id 
ORDER BY dep.department_id;

''' Number 5: Show any employee who earns the same or more salary as her/his manager. Show the first name, last name, job id, and salary of the employee, and the first name, 
last name, job id, and salary of the manager. Use meaningful column aliases throughout.'''

Select em.first_name AS "Employee First Name", em.last_name as "Employee Last Name", em.salary as "Employee Salary", em.job_id AS "Employee Job ID", ma.first_name AS "Manager First Name", ma.last_name AS "Manager Last Name", ma.job_id AS "Manager JOB ID", ma.salary AS "Manager Salary"
FROM employees em 
JOIN employees ma ON em.manager_id = ma.employee_id 
WHERE em.salary >= ma.salary;

'''Show the previous jobs of the employees. For each previous job, show their first and last names, current job id, previous job id, previous job start date, and previous job end date. 
Sort the result by last name and end date. Use column aliases to clarify the two job columns'''

Select curr.first_name ||"Previous Jobs"|| curr.last_name AS "Employee", currently.job_id AS "Current Job", prejob.job_id AS "Prev Job", prejob.end_date AS "Prev Job End Date",
prejob.start_date AS "Prev Job Start Date"
FROM employees curr
JOIN JOB_HISTORY prejob ON curr.employee_id = prejob.employee_id
ORDER BY curr.last_name, pre_job.end_date;

''' Number 7: Show any employee who is not a manager, but earns more than any manager in the employees table. Show first name, last name, job id, and salary. Sort the result by salary.  '''

Select first_name, last_name, job_id, salary 
FROM employees 
WHERE employee_id NOT IN(Select manager.employee_id FROM employees emp JOIN employees manager ON emp.manager_id = manager.employee_id) 
AND salary > ANY(Select manager.salary FROM employees emp JOIN employees manager ON emp.manager_id = manager.employee_id)
ORDER by salary;

''' Number 8: For every geographic region, provide a count of the employees in that region. Display region name, and the count. 
Be sure to include all employees, even if they have not been assigned a department. Sort the result by region name.  '''

Select reg.region_name AS "Regions", count(em.employee_id) AS "Number Of Employee"
FROM regions reg
LEFT JOIN countries cou ON cou.region_id = reg.region_id
LEFT JOIN locations loc ON loc.country_id = cou.country_id
LEFT JOIN departments dep ON dep.location_id = loc.location_id 
FULL JOIN employees em ON em.department_id = dep.department_id 
GROUP BY reg.region_name
ORDER BY reg.region_name;
