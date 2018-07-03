/* Chapter-3: Combining Tables Horizontally using PROC SQL****************************************************************************************/
* General Notes;
* We can combine tables horizontally using JOINS in PROC SQL which is more simple compare to Data steps;
* Remember PROC SQL SELECT generates report and not datasets, while data step creates dataset;

* SQL - has 6 types of joins, they are;
	*1. Simple Join
	*2. Inner Join (Equi Join is part of it);
	*3. Self Join;
	*4. Left Outer Join;
	*5. Right Outer Join;
	*6. Full Join;

* Joins are more efficient when compare to Subqueries;
* Simple Join is like joing two diff tables which have no common attributes;
* select * from table1, table2;
* This will form a cartesian product - that is each row of table-1 is combined with each row of table-2, thus forming a huge table;
* Cartisian product are not usefull by themself, they are useful only with specific where conditions in place;
* This brings us to the concept of Inner Join and Outer Join;

* Inner Join - THese are rows which have common matching values between two tables based on a column attribute used in where condition;
* select * from table1, table2 where table1.PK = table2.PK;

* using ON operator;
* Outer joins induce missing values;
* LEFT OUTER JOIN - These are all records in table-1 and matching records from table 2;
* SELECT * FROM table1 left join table2 on condition;

* RIGHT OUTER JOIN - These are all records from table-2 and matching records from table-1;
* SELECT * FROM table1 right join table2 on condition;

* FULL JOIN - These are all matching and non-matching records from both Table-1 and Table-2, but not the cartesian product as such, due to the presence of JOIN condition;
* SELECT * FROM table1 full join table2 on condition;

* SELF JOIN - It is the JOIN on its own table itself;
***********************************************************************************************************************************;

* 1. Understanding Joins;
* Joins combine tables horizontally by combining the rows;
* We can use join to combine both tables and views;
* There are 2 main types of Joins:
	1. Inner Join - Only the interaction (matching) rows, join two tables based on a common matching column values
	2. Outer Join - Interaction (matching) + Non matching rows from one or more tables;
* Whatever join is used, system will produce a cartisian product;
* Cartisian Product - It is a combination of all possible rows from all tables;

* 2. Simple Join and Generating Cartisian Product (CP);
* CP is generated when you specify multiple tables in FROM clause, but do not include a WHERE statement to subset data;
* You can also create a temprovary table alias in the from clause as shown below;
* CP includes all collumns from the source tables, columns that have common names are not overlaid;
* in below table we see Dateofbirth and dateofhire appears twice, they are not over laid;
* Number of rows returned by a cartisian product is the NumberOfRows_in_Table1 * NumberOfRows_in_Table2;
* lets say if each table has 3 rows, then CP will return 3*3=9 rows as CP;
* For any type of JOIN written, a cartisian product is formed in the backend;
* CP in huge table might produce a big dataset, when SAS is unable to handle (Query is not optimized) such scenario, it will through a note in log;
PROC SQL;
	select * from sasuser.payrollchanges PC, sasuser.payrollmaster PM;
QUIT;
* OUTOBS is used to restrict the number of rows displayed;
PROC SQL OUTOBS=10;
	select * from sasuser.payrollchanges PC, sasuser.payrollmaster PM;
QUIT;

* 3. Inner Join and Equi Join;
* This is the most simplest type of join;
* Only display rows from table-1 which matches with rows from table-2, based on a matching criteria;
* WHERE clause is mostly used to create the matching criteria;
* you can max join 32 table with a single select inner join;
* if a join is based on views, it is the number of tables underlie in view is what matter wrt above 32 count and not the number of view itself;
* due to WHERE clause not all rows of cartisian products are displayed, WHERE can use =, < or >;
* very important, collumn used to join two tables must be of same datatype;
* When the matching columns in table-1 and table-2 are same then we call that particular inner join as EquiJoin;
* even in below queary you see the dateof birth is displayed twice because of the formation of cartisian product in the backend;
PROC SQL;
	select * from sasuser.payrollchanges PC, sasuser.payrollmaster PM
	where PC.EMPID = PM.EMPID;
QUIT;

* 3.2. Understanding Joins processing in SAS;
* Below is the process how JOINS are handled in SAS:
	* a. Build a cartisian product
	* b. Apply filter condition based on WHERE
	* c. summurize the applicable rows if any summary function is used
	* d. produce output;
* However, practically PROC SQL follow other complex process to fetch even more quicker results;
* By default the columns are not overlaid, columns are duplicated due to CP formation;
PROC SQL;
	select * from sasuser.payrollchanges PC, sasuser.payrollmaster PM
	where PC.EMPID = PM.EMPID and PC.GENDER='M';
QUIT;

* 3.3. Eliminating Duplicate Columns;
* As said above, by default the columns are not overlaid, columns are duplicated due to CP formation;
* COALESCE is used to overlay collumns with same name, we will discuss this COALESCE with outter joins;
* Method-1: Use the select appropriately without using *;
PROC SQL;
	select PM.EMPID,PM.GENDER,PC.SALARY from sasuser.payrollchanges PC, sasuser.payrollmaster PM
	where PC.EMPID = PM.EMPID and PC.GENDER='M';
QUIT;
* Method-2 you can use all columns from table 1 and only few from table-2;
PROC SQL;
	select PM.*, PC.EMPID from sasuser.payrollchanges PC, sasuser.payrollmaster PM
	where PC.EMPID = PM.EMPID and PC.GENDER='M';
QUIT;

* 3.4. Renaming the column;
* AS operator is used in SELECT;
PROC SQL;
	select PM.EMPID as PM_EMPLOYEEID,PM.GENDER,PC.SALARY from sasuser.payrollchanges PC, sasuser.payrollmaster PM
	where PC.EMPID = PM.EMPID and PC.GENDER='M';
QUIT;
* Column alias used can be used in where condition too;
PROC SQL;
	select PM.EMPID as PM_EMPLOYEEID,PM.GENDER,PC.SALARY from sasuser.payrollchanges PC, sasuser.payrollmaster PM
	where PC.EMPID = PM_EMPLOYEEID and PC.GENDER='M';
QUIT;

* 3.5. Joining tables with matching rows;
* Due to Cartisian Product, common rows are duplicated with conbination of other distinct rows;
* No two records will be same here anyways;
* Also match-merge works totally in a different way as it combined two tables from top to bottom;
* creating two sample dataset;
DATA THREE;
	INPUT X A $;
	datalines;
1	a1
1	a2
2	b1
2	b2
4	d
;

DATA FOUR;
	INPUT X B $;
	datalines;
2	k1
2	k2
3	y
5	v
;

PROC SQL;
	select * from THREE, FOUR where THREE.X=FOUR.X;
RUN;

* 3.6. Specifying table Alias;
* Table alias is created by prefixing table name before the column name using a period;
* It is a temporary name but it is easy to read;
* These are easy to read and access but it is not quick;
* table alais is optional, only place it is used more are 1. Self Join and 2. Same Named tables in diff directory;
PROC SQL;
	select  T.A, F.B from THREE T, FOUR F where THREE.X=FOUR.X;
RUN;
* We can even use AS to create a table alaias;
PROC SQL;
	select  T.A, F.B from THREE AS T, FOUR AS F where THREE.X=FOUR.X;
RUN;
* Self Join - These are join on a table to itself;
PROC SQL;
	select  T1.X, T2.A from THREE AS T1, THREE AS T2 where T1.X=T2.X;
RUN;
* Concatenating two collumns in select statement;
* Concatenation is done using ||;
* Remember you can only concatenate only two character operand;
* Thus below SQL will through error, because you are trying to join two numeric columns;
PROC SQL;
	select T.X || '.' || F.X as X_Value, A, B from THREE T, FOUR F where THREE.X=FOUR.X;
RUN;
* Let is correct this by concatenating only char;
PROC SQL;
	select T.A || '.' || F.B as T_F_Value, T.X, F.X from THREE T, FOUR F where THREE.X=FOUR.X;
RUN;

* 4. Outer Join;
* It return Inner Join + additional non matching rows from one or more tables based on condition;
* thus it is an augumentation of inner join;
* Outer join can be performed only on 2 tables or views at a time;
* left outer join - Inner join + Non mAtching rows from table in left (table1);
* SELECT * FROM table1 left join table2 on joincondition;
* right outer join - Inner Join + Non Matching rows from table in right (table2);
* SELECT * FROM table1 right join table2 on joincondition;
* full outer join - All Matching Rows + All Non Matching Rows from both tables. However, this is not same as Cartisian Products result;
* SELECT * FROM table1 full join table2 on joincondition;
* In joins mostly ON and WHERE goes HAND in Hand, ON helps in forming join and WHERE helps to subset further;
*In all 3 outer joins columns in the results with the unmatched row are set to missing values;
* remember ON can carry more than one condition;

* 4.1 Left Outer Join;
* Join two table and select rows whcih are common to each other + non-matching rows from table in left (table mentioned 1 in query);
* let us create a dataset for the same;
DATA One;
	input x A $;
	datalines;
1	a
2	b
3	d
;
DATA Two;
	input x B $;
	datalines;
2	x
3	y
5	v
;
* Creating left outer join;
PROC SQL;
	select * from one left join two on one.x=two.x;
QUIT;
* Above program will produce duplicate column, to avoid this we can use SELECT efficiently by mentioning the column explicitly;
PROC SQL;
	select one.x,A,B from one left join two on one.x=two.x;
QUIT;

* 4.2 Right Outer Join;
* Join two table and select rows whcih are common to each other + non-matching rows from table in right (table mentioned 2 in query);
* Creating left outer join;
PROC SQL;
	select * from one right join two on one.x=two.x;
QUIT;
* slecting needed col;
PROC SQL;
	select two.x,A,B from one right join two on one.x=two.x;
QUIT;

* 4.3 Full Outer Join;
* Join two table and select matching + non-matching rows from both tables based on join conditions;
* Creating full outer join;
PROC SQL;
	select * from one full join two on one.x=two.x;
QUIT;
* inner join can also be coded in same style, but it restricts join only on 2 table and not 32 table;
PROC SQL;
	select * from one inner join two on one.x=two.x;
QUIT;
* slecting needed col;
PROC SQL;
	select two.x,A,B from one right join two on one.x=two.x;
QUIT;

* 5. Comparing SQL Join and Data Step Match-Merge;
* Data step match merge functionality and PROC SQL join does the same functionality in merging multiple tables horizontally;
* Main difference is Match-merge need data to be sorted based on collumn that is been used to merge;
* Also match merge created dataset while PROC SQL will create Report;
* To convert PROC SQL report to a dataset we need to pass the info to CREATE TABLE script;
* Also, try to avoid ORDER BY clause in PROC SQL, so that SAS will avoid the second pass and thus becomes efficient;
* While we dont need to sort the table before Merging in PROC SQL;
* Merging can be disccused with two cases, when all rows matches like a equi join and when only some of the rows matches;
* Case-1 - When all of the value match - DATA STEP MERGE vs PROC SQL INNER JOIN;
* Before using match merge, data needs to be sorted;
DATA FIVE;
	INPUT X A $;
	datalines;
1	a
2	b
3	c
;
DATA SIX;
	INPUT X B $;
	datalines;
1	x
2	y
3	z
;
PROC SORT DATA=FIVE;
	BY x;
PROC SORT DATA=SIX;
	BY x;
RUN;
QUIT;
* performing match merge;
DATA data_merged;
	merge FIVE SIX;
	by x;
RUN;
QUIT;
PROC PRINT DATA=data_merged;
RUN;
* Same can be acheived with inner join in PROC SQL;
PROC SQL;
	SELECT Five.X,A,B FROM FIVE,SIX where Five.X=Six.X;
QUIT;

* Case-2 - Dataset with only few rows matching & Without COALESCE;
* FULL OUTER JOIN is the best substitute;
DATA SEVEN;
	INPUT X A $;
	datalines;
1	a
2	b
4	d
;
DATA EIGHT;
	INPUT X B $;
	datalines;
2	x
3	y
5	v
;
RUN;
QUIT;
* Data step Match Merge will take care of collating duplicate collumns and thus automatially overlays;
* However, PROC SQL doesnt overlay by default, in order to overlay the table COALESCE;
* PROC SQL full outer join is the substitute for this type of match merge;
* Remember match merge go in order and it will look for data to be sorted before it is merged;
PROC SORT DATA=seven;
	BY x;
PROC SORT DATA=eight;
	BY x;
RUN;
QUIT;
DATA match_merge_2;
	merge seven eight;
	by X;
PROC PRINT DATA=match_merge_2;
RUN;
QUIT;
* We can acheive the same result using the FULL outer join;
* With below code we see duplicate in two coulmn of X;
* This is because PROC SQL cannot COALESCE or overlay by default;
PROC SQL;
	SELECT * from seven full outer join eight on seven.x=eight.x;
RUN;
QUIT;

* Case-2 With COALESCE;
* to get he exactly same result as the above match merge program, we need to use COALESCE function in SELECT;
* Remember COALESCE should be used with SELECT and not with PROC SQL;
* And COALESCE is done on some particular columns that needs to be overlaid;
PROC SQL;
	SELECT COALESCE(seven.x, eight.x) as y, A, B from seven full outer join eight on seven.x=eight.x;
RUN;
QUIT;

* 6. Inline View;
* These are temporary Views which reduces complexity and improve efficiency;
* These are define in the from - that is defining a new seclect statemennt in from;
* We can specify more than one table in the FROM CLAUSE of the inline view too;
* Use AS to define a table alais;
PROC SQL;
	select x from (select x from seven);
QUIT;
END;
