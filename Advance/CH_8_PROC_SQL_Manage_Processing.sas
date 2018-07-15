/* Chapter-8: Managing Processing using PROC SQL */
* IN SAS using PROC SQL we can control:
	1. Execution
	2. Output
	3. Testing and Evaluation;
* SAS Session metadata is stored in Dictionary Table;
* Meta Data is a Data about a Data;
* Dictionary Table contains:
	1. Info about all SAS Files
	2. Info about settings
	3. System Options
	4. SAS Titles
	5. Data Libraries
	6. Datasets
	7. Macros;

* 1. Specifying SQL OPtions;
* SQL options are specified in PROC SQL;
* PROC SQL <options>;
* Life time of these optiosn are until they are changed or RESET or if that particular PROC SQL is re-invoked;
PROC SQL inobs=5;
	select * from sasuser.acities;
QUIT;

* 2. Controlling the Execution;
* These are options that control executions in SAS;
* They reduce time taken to process and increase efficiency at times;
* Subsetting Rows is one method of controlling executions, below are few options available in SAS:
	1. WHERE condition - Used to subset rows required
	2. INOBS - Force SAS to read only those many records from each tables/views
	3. OUTOBS - Reads whole table but Force SAS to write only those many rows to output;

* 2.1. INOBS - Mention number of rows to be read from each table mentioned under that PROC SQL and not a combined row count;
* In below program only 5 records are read from each table;
PROC SQL INOBS=5;
	SELECT * FROM SASUSER.mechanicslevel1
	OUTER UNION CORR
	SELECT * FROM SASUSER.mechanicslevel2;
QUIT;
* OUTOBS - All records are read from each table but finally only mentioned number of rows get printed;
PROC SQL OUTOBS=5;
	SELECT * FROM SASUSER.mechanicslevel1
	OUTER UNION CORR
	SELECT * FROM SASUSER.mechanicslevel2;
QUIT;

* 2.2. PROMPT | NOPROMPT - These are used to mention SAS to PROMPT when any of the above PROC SQL option is used;
* User is prompted to stop or continue processing when file limit set by these options are reached;
* Prompt dialogue box appear, you can either stop or continue the execution;
* PROMPT - prompts user to see if SAS should proceed or stop procesing the stmt;
* NOPROMPT - Doesnt PROMPT the user;
* Be clear on how PROMPT works;
* In the below query, PROMPT is applied to each SQL, first PROMPT is done for table mechanicslevel1;
* Either when we hit Stop or when all record from table1 is read, PROMPT gets activated for table2;
PROC SQL INOBS=2 PROMPT;
	SELECT * FROM SASUSER.mechanicslevel1
	OUTER UNION CORR
	SELECT * FROM SASUSER.mechanicslevel2;
QUIT;
* PROMPT at individual level;
* Even in the below query PROMPT is applied for each SQL statement, first all prompts are for mechanicslevel1 table;
* After we hit Stop, PROMPT gets activated for mechanicslevel2;
PROC SQL INOBS=2 PROMPT ;
SELECT * from SASUSER.mechanicslevel1;
SELECT * from SASUSER.mechanicslevel2;
QUIT;

* 3. Controlling the Output;
* 3.1. NUMBER|NONUMBER is one of the output control option;
* NONUMBER is the default for PROC SQL;
* These are similar to OBS and NOOBS options in PROC print procedure;
* Remember OBS and NOOBS are not valid PROC SQL options, use either NUMBER or NONUMBER;
PROC SQL NUMBER;
	select * from sasuser.acities;
QUIT;

* 3.2. Double spacing output;
* DOUBLE|NODOUBLE will help to double space the output and make it easier to read;
* However, it is only for SAS output and not for HTML/ODS report;
PROC SQL DOUBLE;
	select flightnumber, destination from sasuser.internationalflights;
QUIT;

* 3.3. Flowing Characters within a column;
* FLOW|NOFLOW or FLOW=n or FLOW=n m options affect how word wrap should behave in SAS output;
* Again this is only for SAS output and not ODS report;
* FLOW this will just make the column to flow in its column instead of wrapping the whole row;
* FLOW=n will set the width of the specific column, any length more than that wil be wrapped to next row but confined within same column width;
* FLOW=n m will make the width to float between limits of n and m to acheive a balanced output;
* Below program without FLOW;
PROC SQL INOBS=5;
	Select ffid, membertype,name,address, city, state, zipcode from SASUSER.FREQUENTFLYERS
	ORDER BY POINTSUSED;
QUIT;
* with FLOW option;
PROC SQL INOBS=5 FLOW;
	Select ffid, membertype,name,address, city, state, zipcode from SASUSER.FREQUENTFLYERS
	ORDER BY POINTSUSED;
QUIT;
* with FLOW=n m option;
PROC SQL INOBS=5 FLOW=10 15;
	Select ffid, membertype,name,address, city, state, zipcode from SASUSER.FREQUENTFLYERS
	ORDER BY POINTSUSED;
QUIT;
* Use FLOW whenever a column values are huge;

* 4. Testing and Evaluation Performance;
* STIMER|NOSTIMER are used to get the time each statement takes execute instead of whole;
* Current setting of these can be seen through PROC OPTIONS;
* NOSTIMER is the default setting;
PROC OPTIONS OPTION=stimer value;
RUN;

* 4.1. If STIMER is used as SAS options, we will get consolidated time of execution;
PROC SQL;
	SELECT * FROM SASUSER.mechanicslevel1;
	SELECT * FROM SASUSER.mechanicslevel2;
QUIT;
* 4.2. If STIMER is used as PORC SQL options, we get time taken by each SQL statement for execution;
* any statement that ends with a semicolon is considered as one SQL statement;
* STIMER with PROC SQL is mostly used during performance measure excersise;
PROC SQL STIMER;
	SELECT * FROM SASUSER.mechanicslevel1;
	SELECT * FROM SASUSER.mechanicslevel2;
QUIT;

* 5. Resetting SAS options;
* RESET is used reset any SAS options;
* RESET is used to add, modify or drop PORC SQL options without reinvoking the SQL procedure;
* Very important - OPTIONS are additive;
PROC SQL;
	select flightnumber, destination from sasuser.internationalflights;
QUIT;
* See how RESET works and observe the additive behaviour;
* For first select statement only OUTOBS is applied;
* For second select statement both OUTOBS + NUMBER is applied;
PROC SQL outobs=5;
	select flightnumber, destination from sasuser.internationalflights;
RESET NUMBER;
	select flightnumber, destination from sasuser.internationalflights;
QUIT;
* In the above program, we see NUMBER got added to the OUTOBS option from previous statement;
* This way the options become additive;
* If you like to RESET the OUTOBS option, then mention OUTOBS= in RESET;
PROC SQL outobs=5;
	select flightnumber, destination from sasuser.internationalflights;
RESET OUTOBS= NUMBER;
	select flightnumber, destination from sasuser.internationalflights;
QUIT;

* 6. Dictionary Tables;
* These are special read only tables that contains:
	1. Info about all SAS Files
	2. Info about settings
	3. System Options
	4. SAS Titles
	5. Data Libraries
	6. Datasets
	7. Macros;
* These are read only and hence:
	cannot modify/alter
	No Constraints can be added;
* Dictionary tables can be accessed like any other tables;
* DESCRIBE TABLE command can be used to see how dictionary table definition is done;
* To get used to dic table or to access it, use DESCRIBE TABLE first, it will print the create table command in SAS log;
* Referring which we can use where clause to select those which are needed;
PROC SQL;
	DESCRIBE TABLE dictionary.tables;
QUIT;

* 6.1 Dictionary.tables - Finding tables associated to a library;
* Let us create some sample tables in WORK library;
* Dictionary tables are dynamic, based on values its structure changes;
PROC SQL;
CREATE TABLE WORK.ACITIES AS
SELECT * FROM SASUSER.ACITIES;
QUIT;
* Finding the libraries in SAS stored in Dict table;
PROC SQL;
	SELECT libname from dictionary.tables;
QUIT;
*Finding the content inside a particular library;
* Try to give library name in capital letter, becuase that is how the names are stored in SAS internally;
* below shows the SAS Object name(like table names), Object type(like table, views), nobs (number of observation the obj carries), libname(library under which obj is stored);
* Results are obtained as ODS reports;
PROC SQL;
	SELECT memname, memtype, nobs, libname from dictionary.tables where libname='SASUSER';
	SELECT memname, memtype, nobs, libname from dictionary.tables where libname='WORK';
QUIT;

* 6.2. Dictionary.columns - To find the tables for a specified column;
* Dictionary tables also contains detailed info about the libraries and its attributes (like table and views;
* Similarly Dictionalry.columns contain detailed informatin about the variables and their attributes (columns) of a table or view;
PROC SQL;
	DESCRIBE table dictionary.columns;
QUIT;
* Again dictionary.columns will have memname(table/view name), memtype(tables/views), libname(name of the library);
* More important is the name (column name), type, length, etc;
* below list the library, tables associated to the lib and columns those tables has;
PROC SQL;
	SELECT libname, memname, memtype, name from dictionary.columns where libname='SASUSER';
	SELECT libname, memname, memtype, name from dictionary.columns where libname='WORK';
QUIT;
* If we just need info about a column name and need to know in which table it exists, we can fire below query;
* Below query will list all the tables from all the libraries which has a column City in it;
* Values provided for search in WHERE clause is case sensitive, i.e. 'City' is different from 'city';
PROC SQL;
	SELECT libname, memname, memtype from dictionary.columns where name='City';
QUIT;
* very important - Similar results can be obtained by reffering to Sashelp library too;
* Dictionary tables can only be accessed using PROC SQL;
* While SASHELP views can be accesses through PROC SQL and Data steps too;
PROC SQL;
	SELECT libname, memname, memtype from sashelp.vcolumn
	where name='City';
QUIT;

* LOOPS= is used to control the iteration, these are generally used with PROMPT;
* Can also use the number of iteration that are reported in the SQLOOPS macro variabel to gauge an appropriate value for LOOPS=;

* 7. Controling Execution;
* 7.1 EXEC | NOEXEC - used to specify whether a statement should be executed after its sysntax is chacked for accurary;
* 7.2. ERRORSTOP | NOERRORSTOP - specify whether PROC SQL stop executing if it encounters error, this is more specific for PROC SQL;
* Default is NOERROSTOP in interactive SAS Session and ERRORSTOP in Batch mode or non-interactive SAS session;
