* * operator;
/* Using the simple * operator to select all rows */
PROC SQL;
	SELECT * FROM SASUSER.PAYROLLMASTER;
QUIT;

* FEEDBACK and OUTOBS SQL OPtions;
/*  FEEDBACK = To print the expanded column list selected, that is if we mention * it select all rows whose names get printed 
	OUTOBS = Number of observation to be printed, here all observations are read but only few observation get printed to o/p */
PROC SQL FEEDBACK OUTOBS=5;
	SELECT * FROM SASUSER.PAYROLLMASTER;
QUIT; 

* DISTINCT = Used to select the unique column value;
PROC SQL;
	SELECT DISTINCT(JOBCODE) FROM SASUSER.PAYROLLMASTER;
QUIT;

* WHERE OPerator used to SUBSET ROWS;
PROC SQL;
	SELECT * FROM SASUSER.PAYROLLMASTER 
	WHERE GENDER = 'M';
QUIT;

* CONTAINS = It list all the string which contains a particular pattern;
* CONTAINS can be used only on the Character columns and not on Numeric column;
* It look for the character combination mentioned after CONTAINS anywhere in the column value;
* For e.g. if we seach for values thatcntain 'ME' and values in col are 'AME', 'MEA', 'ABMEA', then all these value gets listed;
* Search is case sensitive, that is SAS search based on the case given in '';
PROC SQL;
	SELECT JOBCODE FROM SASUSER.PAYROLLMASTER
	WHERE JOBCODE CONTAINS 'a';
QUIT;

* BETWEEN ... AND =  Used to select the values based on a range of values;
* Range mentioned is inclusive;
* Order of range being mentioned doesnt matter;
PROC SQL;
	SELECT EMPID FROM SASUSER.PAYROLLMASTER
	WHERE EMPID BETWEEN '1500' AND '2000';
QUIT;

* IS NULL  = Check for any NULL Values;
* IS MISSING = Used to check if column values are missing;
* To check the missing values, you can use . dot operator for numeric attributes or even '' blank operator for char attributes;
* It is always a good habit to check logs to validate our execution;
PROC SQL;
	SELECT EMPID FROM SASUSER.PAYROLLMASTER
	WHERE EMPID IS NULL;
QUIT;

PROC SQL;
	SELECT EMPID FROM SASUSER.PAYROLLMASTER
	WHERE EMPID IS MISSING;
QUIT;
* missing value can alos be checked using . and '';
PROC SQL;
	SELECT EMPID FROM SASUSER.PAYROLLMASTER
	WHERE EMPID = '';
QUIT;

* LIKE = used to select the cols starting with some set of chars;
* '_' = used to select one char;
* '%' = used to select more than one char;
PROC SQL;
	SELECT JOBCODE FROM SASUSER.PAYROLLMASTER
	WHERE JOBCODE LIKE '_E_';
QUIT;

PROC SQL;
	SELECT JOBCODE FROM SASUSER.PAYROLLMASTER
	WHERE JOBCODE LIKE 'P%';
QUIT;

* =* this is a sounds like operator, it picks all values which counds like them;
* It works on SOUNDEX algorthm;
* Biased to only English language for now;
* works on the sound of the syllabels;
PROC SQL;
	SELECT JOBCODE FROM SASUSER.PAYROLLMASTER
	WHERE JOBCODE =* 'PETE';
QUIT;


* CALCULATED = used to indicate the collumn is calculated for WHERE clause;
* Collumn which are derived using expression when used in other than select statement, we need to use CALCULATED to mention SAS to consider it has a derived field;
PROC SQL;
	SELECT JOBCODE, EMPID, Salary, (Salary + (Salary*0.5)) as Bonus
	FROM SASUSER.PAYROLLMASTER
	WHERE CALCULATED Bonus > 50000;
QUIT;

* Let us now format the above Queary;
* Title = Used to provide a Title to the Proc SQL;
* FootNote = Used to provide the foot note to the Proc SQL;
* Label = Used to provide a label or a column alias;
* Format = Mention the SAS Format;
* For a col all these label and format definitions must be placed consiqutively before defining next column using , comma;
* for e.g. Select Col1 label='label1' format=DOLLAR8., Col2, col3 label 'label3' from tablename where condition;
* do not forget to use = while defining a label or a format;
* title and footnote can be given before and after PROC SQL but not inside a SQL clauses;
PROC SQL;
	title 'Sample formatting';
	footnote 'done!!!';
	SELECT JOBCODE, EMPID, Salary, 
	(Salary + (Salary*0.5)) as Bonus
	label = 'Bonum Salary'
	format = dollar12.2
	FROM SASUSER.PAYROLLMASTER
	WHERE CALCULATED Bonus > 50000;
	title;
	footnote;
QUIT;

/* group by */
* group by without a summary function will just list the table in a sorted order, default sorting is in asscending;
PROC SQL;
	SELECT * FROM SASUSER.PAYROLLMASTER
	GROUP BY JOBCODE;
QUIT;

/* Aggregate Function - AVG = Average */
/* Having = Subset the group by clause - CALCULATED is not required here unlike WHERE condition */
PROC SQL;
	SELECT Jobcode, 
	avg(salary) as Avg_Salary format = dollar12.2
	FROM SASUSER.PAYROLLMASTER 
	GROUP BY JOBCODE
	HAVING Avg_Salary > 50000;
QUIT;

/* Count(*) = Count of all not null values, that is all rows with no NULL values in even a single column */
PROC SQL;
	SELECT count(*) as Total_Rows from SASUSER.PAYROLLMASTER;
QUIT;

/* count(Col) = Non missing values from a particular column */
PROC SQL;
	SELECT count(jobcode) as Total_Rows from SASUSER.PAYROLLMASTER;
QUIT;

/* count(distinct col) = Count of distinct values */
PROC SQL;
	SELECT count(distinct jobcode) as Total_Rows from SASUSER.PAYROLLMASTER;
QUIT;


/* Sub-Queries */
/* Correlated = Where Child depend on Parent */
/* Non-Correlated = Where Child doesnt depend on Parent */
/* Remember always JOIN is better than sub-queries in terms of performance */

/* 1. Single value Non-correlated subquesries */
* Child Query is not dependent on parent and it will return only one single value to its parent;
PROC SQL;
	SELECT * from SASUSER.PAYROLLMASTER
	where salary > (select avg(salary) from SASUSER.PAYROLLMASTER);
QUIT;
/* 2. Multiple Value Non-Correlated Subqueries */
/* We should basically use the IN operator */
/* IN operator can handle multiple value matching */
PROC SQL;
	SELECT * from sasuser.staffmaster
	WHERE empid in
		(select empid from sasuser.payrollmaster where month(dateofbirth)=2);
QUIT;
/* ANY */
/* It will choose if atleast one of the result returned by subquery matches the condition, then parent query will be executed */
/* can also use Max(dateofbirth) function  for efficient coding */
PROC SQL;
	SELECT * from SASUSER.PAYROLLMASTER
	where jobcode in ('FA', 'FA2') and dateofbirth < any
	(select dateofbirth from sasuser.payrollmaster where jobcode='FA3');
QUIT;
/* ALL */
/* It will choose only if all of the result returned by subquery matches the condition, then parent query will be executed */
/* Can also use Max(dateofbirth) function  for efficient coding */
PROC SQL;
	SELECT * from SASUSER.PAYROLLMASTER
	where jobcode in ('FA', 'FA2') and dateofbirth < all
	(select dateofbirth from sasuser.payrollmaster where jobcode='FA3');
QUIT;

/* Sunsetting data using correlated sub-queries*/
/* Child query depends on the parent queary */
/* Remember JOIN is the most efficient alternative to a correlated sub-query */
/* EXIST - Sub-query Returns atleast one row */
/* NOT EXIST - sub-query returns no data */
* You can use this in both where or having clause;
* You should be using not exist like, lets say there are two tables with some interaction of data;
* So if we need data from one table which is not existing in interaction ot another table (that is data only from set1-interaction term) is called Non-Existance;
PROC SQL;
	SELECT * from sasuser.flightattendants 
	where not exists
	(select * from sasuser.flightschedule where flightschedule.empid=flightattendants.empid);
QUIT;

/* Validating the Syntax */
* Use VALIDATE before the actual SQL statement, that is just next to PROC SQL statement;
* check log after running below code, if you see no error or warning it means PROC SQL command looks good;
* Remember VALIDATE is the part of the QUEARY and not PROC SQL;
* VALIDATE will only affect the SQL statement which is next after it, thats it;
* Thats why the statement start with VALIDATE followed by SQL stmt and ends with semicolan;
PROC SQL;
VALIDATE
SELECT * FROM sasuser.flightattendants;
QUIT;

*Stopping execution;
* NOEXEC is used to stop the execution of the SQL;
* NOEXEC will affect the who PROC SQL procedure, none of the SQL statements inside PROC SQL will get executed;
PROC SQL NOEXEC;
	select * from sasuser.flightattendants;
QUIT;
