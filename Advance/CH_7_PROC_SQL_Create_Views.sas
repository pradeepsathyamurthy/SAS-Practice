/* Chapter-7: Creating and Managing Views */
* Total Revision Time: 20 to 25 Mints;
* Views are stored query expression, they are created from
	1. SAS Data File
	2. Dataset Views
	3. PROC SQL Views
	4. DBMS Data
View derives its data from tables or views
Data accessed by Views are either subset or superset of the data that is in the underlying table;

* 1. Creating PROC SQL Views;
* 	Views contain only logic (in query form) for accessing the data and not the data itself
	It is called the virtual table, It is like a window to the table
	View is also considered as one of the SAS Dataset type
	It is used to:
		1. Save Spaces
		2. Refer upto date data
		3. Keep data secure
		4. Encapsulate Complex logics;
* They basically derive data from one or more tables or views;
* Most of the commands correlates with PROC SQL table commands;
* When a view is created there is no reports gets generated;
* Just the code is compiled and stored in system;
* Default view extension in SAS is .sas7bvew;
* Default library is the Work library;
PROC SQL;
	CREATE VIEW acities
	as
	SELECT * from sasuser.acities;
QUIT;

* 2. Using PROC SQL Views;
* Can use view in the same way as we use tables;
* When a view get executed only conceptually(not physically) an internal table is built;
* SAS assumes the reference tables/views are from same library where views reside;
* Using a 2 level name depends on the context;
* As mostly when 2 level name is used and the directory of source data or view changes, then view needs to be rewritten;
PROC SQL;
SELECT * from work.Acities;
QUIT;
* Views once created can be used in other PROC or Data steps;
PROC PRINT DATA=work.Acities(obs=5);
RUN;

* 3. Describing the definition of a view;
* DESCRIBE VIEW is used to display the definition of a view in SAS log;
* This will logically disply the select query used to create the view in SAS log;
PROC SQL;
	DESCRIBE VIEW work.acities;
QUIT;
* If we build a view from a view instead of a table basically, and if we need to see the definition of parent view we use FEEDBACK;
* FEEDBACK is a PROC SQL option;
* Generally used for debugging;
PROC SQL FEEDBACK;
	DESCRIBE VIEW work.acities;
	SELECT * from work.Acities;
QUIT;

* 4. Managing the PROC SQL Views;
* 4.1. Places where creating views can be avoided:
	a. When same column is used multiple times and in multiple programs
	b. When a table is subjected to frequent changes
* 4.2. Guidelines to create views
	a. Do not build a view with ORDER BY clause init
	b. It is recommended to use one level name for views based on the context of usage
	c. One level name if view and table reside in same library
	d. Two level name if view and table reside in different library;
* 4.3. Embedded LIBNAME statement by 'USING'
	a. 'USING LIBNAME' is used to avoid any confusions wrt one level or two level file names to be given for a view
	b. USING clause is the last statement in the create view statment
	c. Till the statement reach USING, the library where view resides get referred
	d. Once the USING is reached, libref mentioned in the USING caluse takes effect;
libname airlines 'SAS-library-One';
PROC SQL;
	create view sasuser.payrollv as 
	select * from airlines.payrollmaster
	USING LIBNAME airlines 'sas-library-two';
quit;
* Thus when we fire a select command or refer the view sasuser.payrollv, then sas-library-two will take effect for that execution;
* SAS system option gets masked;
PROC PRINT DATA=sasuser.payrollv;
RUN;
QUIT;

* 5. Views for table security;
* View is used to sheild sensitive and confidential columns
* However, it is recommended to use the security feature of OS instead depending on SAS;

* 6. Updating PROC SQL;
* We can update columns through view only in below conditions:
	1. Data is updated on a single table
	2. Can update only the real column even using column alias but not the derived column
	3. Cannot update a view which has ORDER BY or HAVING clause, update is possible with WHERE clause
	4. Cannot update summary views those which uses GROUP BY;
* Remember when you update a view only the data in the underlying table is updated as view is just a stored query expression;
* It is like updating a table through views;
* Not just UPDATE, you can even Delete and insert data using views;
PROC SQL;
	UPDATE work.acities 
	set country='United States of America'
	where country='USA';
QUIT;
PROC SQL;
	DELETE FROM work.acities 
	where country='United States of America';
QUIT;
PROC SQL;
	INSERT INTO work.acities(city,code,name,country)
	VALUES ('Chicago', 'CHI', 'ORD Airport', 'USA')
	VALUES ('Texas', 'TEX', 'TXT Airport', 'USA')
	VALUES ('Michigan', 'MHI', 'MIC Airport', 'USA');
QUIT;
PROC PRINT DATA=work.acities;
RUN;
QUIT;
PROC PRINT DATA=SASUSER.acities;
RUN;
QUIT;

* 7. Dropping PORC SQL Views;
* It is like a DROP Table command;
* We can provide multiple view names in a sinle drop statement;
PROC SQL;
	DROP VIEW work.acities;
QUIT;
PROC PRINT DATA=work.acities;
RUN;
QUIT;
PROC PRINT DATA=SASUSER.acities;
RUN;
QUIT;
