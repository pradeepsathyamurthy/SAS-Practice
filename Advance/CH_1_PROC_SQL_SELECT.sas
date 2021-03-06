* Pradeep Sathyamurthy - 2018;
/* Chapter-1 Practice
	This is a practice on PROC SQL command
	This Chapter deals with basic SQL query */

* Average Revise time for this topic should be between 10 and 15 mints;

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
	SELECT EmpID,Gender,JobCode,Salary, (salary*0.8) as Bonus format=Dollar8. FROM SASUSER.PAYROLLMASTER;
QUIT;

* Subsetting or Filterring column;
* Use WHERE Condition;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000;
QUIT;

* Ordering or sorting the rows;
* 'ORDER BY' is used;
* default ordering is ascending;
* to order in descending order use DESC in the ORDER BY statement;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000
	ORDER BY SALARY;
QUIT;

* Default sorting is ASC;
* To order by in Descending order, need to use DESC clause;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000
	ORDER BY SALARY DESC;
QUIT;

* Can use the column index or position in ORDER BY clause;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary
	FROM SASUSER.PAYROLLMASTER
	WHERE Salary > 100000
	ORDER BY 4 DESC;
QUIT;

* Multiple column ordering;
* Sorting first happen on first column mentioned, here for e.g. on SALARY column;
* If there are any two salary which are equal, then sorting of those two record happen based on column mentioned second, here Gender col;
PROC SQL;
	SELECT EmpID,Gender,JobCode,Salary, (salary*0.8) as Bonus 
	FROM SASUSER.PAYROLLMASTER
	ORDER BY SALARY, Gender;
QUIT;

* Inner Join;
* Quering multiple columns from multiple tables;
* This is called SQL Join - that is joining the tables horizontally;
* JOIN we do here inner join where column is joined based on a common column;
* In this e.g. lets join 2 tabled SALCOMPS and NEWSALS;
PROC SQL;
	SELECT S.EmpID,S.LastName,S.Phone,S.JobCode,S.Salary format=Dollar8.,N.NewSalary
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
* Table is one type of SAS dataset, once created same can be accessed using PROC SQL & even Proc step;
PROC SQL;
	* Create Table script;
	CREATE TABLE WORK.TEMP_SALCOMP AS
	SELECT S.JobCode,sum(S.Salary)as TotalSal
	FROM SASUSER.SALCOMPS S, SASUSER.NEWSALS N
	WHERE S.EMPID = N.EMPID
	GROUP BY S.JOBCODE
	HAVING TotalSal > 50000
	ORDER BY TotalSal;

QUIT;

*Checking the table created;
PROC SQL;
	SELECT * FROM WORK.TEMP_SALCOMP;
QUIT;

PROC PRINT DATA=WORK.TEMP_SALCOMP NOOBS;
RUN;
QUIT;

* VIEW style query;
* In this below example we are trying to create a temporary view in WORK folder;
* CREATE VIEW and 'AS' keyword is used create the view;
* View is also one type of SAS dataset, once created same can be accessed using PROC SQL & even Proc step;
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

* Validating the VIEW using PROC Step;
PROC PRINT DATA=WORK.TEMP_VIEW_SALCOMP noobs;
RUN;
QUIT;

/* Sample Practice, try to download the sample data frin Help menu */
PROC SQL;
	SELECT empid, gender, jobcode, salary 
	FROM sasuser.payrollmaster
	WHERE gender='M'
	GROUP BY jobcode;
QUIT;

PROC SQL;
	SELECT jobcode, sum(salary) as TotSalary
	FROM sasuser.payrollmaster
	WHERE gender='M'
	GROUP BY jobcode
	HAVING TotSalary > 50000
	ORDER BY totsalary;
QUIT;

PROC SQL;
	SELECT jobcode, sum(salary) as TotSalary
	FROM sasuser.payrollmaster
	WHERE gender='M'
	GROUP BY jobcode
	HAVING TotSalary > 50000
	ORDER BY totsalary desc;
QUIT;
