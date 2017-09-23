/* Chapter-1 Practice
	This is a practice on PROC SQL command
	This Chapter deals with basic SQL query */

* These PROC SQL statements do not need RUN statement in last;
* However, it is a good coding practice to use QUIT whenever a PROC SQL procedure is used in SAS;

/* There are basically 3 type of output for SQL Proc:
	1. Report - Select
	2. Table - Create Table and Select
	3. View - Create View and Select */

* Reporting style query;
PROC SQL;
	SELECT * FROM SASUSER.PAYROLLMASTER;
QUIT;


* Selecting columns;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary FROM SASUSER.PAYROLLMASTER;
QUIT;

* Creating New derived Columns;
* Bonus of 80% of salary is the new derived column;
* 'AS' key word can be used even as alias;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary, (salary*0.8) as Bonus FROM SASUSER.PAYROLLMASTER;
QUIT;

* Subsetting or Filterring column;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000;
QUIT;

* Ordering the rows;
* 'ORDER BY' is used;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000
	ORDER BY SALARY;
QUIT;

* Default sorting is ASC;
* To default it in Descending order, need to use DESC clause;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000
	ORDER BY SALARY DESC;
QUIT;

* Can use the column index in ORDER BY clause;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000
	ORDER BY 4 DESC;
QUIT;

* Multiple column ordering;
* Sorting first happen on first column mentioned, here for e.g. on SALARY column;
* If there are any two salary which equal, then sort of those two record happen based on column mentioned secon, here EMPID col;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary, (salary*0.8) as Bonus 
	FROM SASUSER.PAYROLLMASTER
	ORDER BY SALARY, Gender;
QUIT;

* Quering multiple columns from multiple tables;
* This is called SQL Join;
* JOIN we do here inner join where column is joined based on a common column;
* In this e.g. lets join 2 tabled SALCOMPS and NEWSALS;
PROC SQL;
	SELECT S.EmpID,S.LastName,S.Phone,S.JobCode,S.Salary,N.NewSalary
	FROM SASUSER.SALCOMPS S, SASUSER.NEWSALS N
	WHERE S.EMPID = N.EMPID
	ORDER by S.LASTNAME;
QUIT;

* Grouping to perform summary statistics based on descritised data;
* GROUP BY Clause is used whenever there is a need of summary statistics on a column;
* 'HAVING' is a key word used as to filter the result obtained from GROUP BY;
* Some of the Summary Stat performed are:
1. MIN, 2. Max, 3.NMISS, 4. PRT, 5. RANGE, 6. STD, 7. STDERR, 8. SUM, 9. T, 10. USS, 11. VAR;
PROC SQL;
	SELECT S.JobCode,sum(S.Salary)as TotalSal
	FROM SASUSER.SALCOMPS S, SASUSER.NEWSALS N
	WHERE S.EMPID = N.EMPID
	GROUP BY S.JOBCODE
	HAVING TotalSal > 50000
	ORDER BY TotalSal;
QUIT;

* Table style query;
* In this below example we are trying to create a temporary table in WORK folder;
* 'AS' keyword is used create the table data;
PROC SQL;
	* Create Table script;
	CREATE TABLE WORK.TEMP_SALCOMP AS
	SELECT S.JobCode,sum(S.Salary)as TotalSal
	FROM SASUSER.SALCOMPS S, SASUSER.NEWSALS N
	WHERE S.EMPID = N.EMPID
	GROUP BY S.JOBCODE
	HAVING TotalSal > 50000
	ORDER BY TotalSal;

	*Checking the table created;
	SELECT * FROM WORK.TEMP_SALCOMP;

QUIT;


* VIEW style query;
* In this below example we are trying to create a temporary table in WORK folder;
* 'AS' keyword is used create the table data;
PROC SQL;
	* Create Table script;
	CREATE VIEW WORK.TEMP_VIEW_SALCOMP AS
	SELECT S.JobCode,sum(S.Salary)as TotalSal
	FROM SASUSER.SALCOMPS S, SASUSER.NEWSALS N
	WHERE S.EMPID = N.EMPID
	GROUP BY S.JOBCODE
	HAVING TotalSal > 50000
	ORDER BY TotalSal;

	*Checking the table created;
	SELECT * FROM WORK.TEMP_VIEW_SALCOMP;

QUIT;
