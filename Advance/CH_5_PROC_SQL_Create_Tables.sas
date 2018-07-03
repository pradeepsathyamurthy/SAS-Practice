/* Chapter-5: Creating and Managing Tables */
* Here we will discuss on how to:
	1. Create and Describe
	2. Inserting Rows to a table
	3. Intergrity constraints
	4. UNDO_POLICY
	5. Updating
	6. Deleting
	7. Altering and 
	8. Dropping the tables;

* 1 Creating and Describing the tables;
* CREATE TABLE is used to create a new table using PROC SQL;
* PROC SQL Select is used to generate the reports and not datasets, if in case you need to convert this report to a dataset;
* we need to use CREATE statements;
* DESCRIBE TABLE is used to explain the table and its contents interms of datatypes, column names and datatype length;
* FORMAT goes hand in hand with column specification;
* When it comes to Datatype in SAS, there are only 2 datatypes 1. NUMERIC and 2. CHAR;
* PROC SQL expose 10 datatypes which are internally converted to either CHAR or Numeric during compilation stage of SAS;
* CHAR, VARCHAR, NUMERIC, DECIMAL, FLOAT, REAL, DOUBLE PRECISION, INTEGER, SMALLINT and DATE;
* Also, Data type length can be defined only for CHAR columns and not for any of the numeric columns;
* This is because for all Numeric columns the default length is set to 8 bytes;
* Create Table;
PROC SQL;
	CREATE TABLE WORK.DISCOUNT(
		Destination char(3),
		BeginDate num format=date9.,
		EndDate num format=date9.,
		Discount num);
QUIT;
* Need to be careful while inserting DATE values; 
* Got to mention the classifier d for the date after the value;
PROC SQL;
	INSERT INTO work.discount
	values('MAS','12May2018'd,'12Jun2018'd,21)
	values('SBC','21Jul2018'd,'2Aug2018'd,31)
	values('KAR','01Oct2018'd,'9Nov2018'd,45);
QUIT;
* Checking the values inserted, good practice to check the logs;
PROC SQL;
	SELECT * from work.discount;
QUIT;

* Describe Table;
* This is like DESC in SQL;
* PROC SQL will not generate o/p for empty tables;
* Table name can be specified in 3 ways:
		1. one-level name filename
		2. two level name libref.filename
		3. physical pathname enclosed in '';
* Multiple tables can be described at a time using one DESCRIBE statement;
* If any index attached even they get displayed using DECRIBE TABLE statement;
* PROC CONTENTS can be used as alternative, but this will generate report and not in the SAS log;
PROC SQL;
DESCRIBE TABLE work.discount;

* There are 3 methods to create a table;
* 	1.1. Creating an Empty table - only CREATE TABLE
	1.2. Empty table with column structure and no rows - LIKE key word is used
	1.3. Table with columns and rows populated - AS key word is used;
* let us duscuss these in detail;
* 1.1. Creating an Empty Table;
* Main thing to note is the column specification, it consist of:
	Column Name
	Datatype
	Column width/datatype length
	Column modifiers (optional) - LABEL, INFORMAT, FORMAT, LENGTH (Length cannot be used in CREATE TABLE, can be used only in SELECT)
	Column Constrains (optional)
	MESSAGE= and MSGTYPE= (optional);
* Very Important - All column definitions are enclosed in (), 
					Each Col Specification is sperated by comma, 
					Each element in a col specification is seperated by a space;
PROC SQL;
	CREATE TABLE WORK.DISCOUNT1(
		Destination char(3),
		BeginDate num format=date9.,
		EndDate num format=date9.,
		Price num informat=dollar.,
		Discount num label='Discounted Price');
* Always have an habit to check the log;
* By default if the libref is not given all tables will be created under WORK library;
* To create permanent table use LIBREF;

* 1.2. Creating an empty table that is like another table - use LIKE keyword;
* LIKE keyword is used;
* Only table structure is created, doesnt have row filled or copied;
PROC SQL;
	CREATE TABLE WORK.Acities
	LIKE SASUSER.Acities;
QUIT;
PROC SQL;
DESCRIBE TABLE work.Acities;
QUIT;
* Specific columns can be selected using KEEP and DROP command;
* should be enclosed in ();
* column spec should be seperated by space in KEEP and DROP;
* KEEP and DROP can be declared either before LIKE or after LIKE operator;
* KEEP and DROP is not part of ASCII standards, it a SAS implementation for PROC SQL;
PROC SQL;
	CREATE TABLE WORK.Acities1
	(DROP=code)
	LIKE SASUSER.Acities;
QUIT;
PROC SQL;
DESCRIBE TABLE work.Acities1;
QUIT;

* 1.3. Creating a table from a query results;
* Use AS keyword followed by a SELECT statement only, you cannot directly give a table name;
* Below program will through error, because table name is defined directly after AS;
PROC SQL;
	CREATE TABLE WORK.ACITIESFILLED
	AS SASUSER.ACITIES;
QUIT;
* Using AS properly;
* In this if we derive any collumn which is not existing in table and forget to give it a name, sas will automatically provide a name for it;
* When a query like SELECT or inline view is used with create table statement, focus is only on CREATING the table and not the report generation;
* Below is the method to even copy the whole table, using SELECT * instead of SELECT <some col names>;
PROC SQL;
	CREATE TABLE WORK.ACITIESFILLED
	AS 
	SELECT * FROM SASUSER.ACITIES;
SELECT * FROM WORK.ACITIESFILLED;
QUIT;

* 2. Inserting rows to a table;
* You can insert rows in 3 different ways:
	2.1 Inserting one observation at a time - SET is used
	2.2 Inserting many observation at a time - VALUES is used
	2.3 Inserting observations through query - SELECT is used
	2.4 INserting Date values into table;
* Lets us look into this in detail;
* 2.1. Iserting one observation at a time, that is inserting column value individually and when the data is new;
* SET operator deals with NAME:VALUE pair;
* Seperate SET caluse is used for each rows;
* Remember you dont need to repeat INSERT INTO multiple time as you do in SQL;
PROC SQL;
INSERT INTO WORK.ACITIES SET
	city='Chennai',
	code='MAS',
	name='Anna International Airport',
	country='India';
QUIT;
* You can use one or multiple SET statement for a single INSERT statement;
* Target column (city, code, name, country) specification before SET statement is optional;
* However, if provided only those columns will be allowed to get inserted;
* No need to maintain order;
* If a column value is unknown you can ignore it and SAS will fill it with missing values . or '' for Numeric and char resp;
* It is a good practice to have Column:Value pair in order to increase productivity;
PROC SQL;
INSERT INTO WORK.ACITIES(city, code, name, country) SET
	city='Bangalore',
	code='SBC',
	name='Kempegowda International Airport',
	country='India'
	SET
	city='Mumbai',
	code='MBM',
	name='Mumbai International Airport',
	country='India';
QUIT;

* 2.2. Inserting Rows by using the Values clause;
* It is VALUES and not VALUE;
* Used to insert multiple list of rows to the table;
* Order is important, should be according to table structure;
* Better to provide a optional column list and then list the values in same order as per optional columm;
* If value is unknown those columns neednot be specified, will be auto filled by SAS as missing values . or '' for Numeric and char resp;
* In generic SQL one Insert statement can have only one Value clause, but in SAS one single Insert statement for a particular table can have multiple VALUES clause;
PROC SQL;
	INSERT INTO WORK.ACITIES(city, code, name, country) 
	VALUES ('Delhi', 'DEL', 'Delhi Airport', 'India')
	VALUES ('Chandigarh', 'CHD', 'Chandi Airport', 'India')
	VALUES ('Pune', 'PUN', 'Pune Airport', 'India');
QUIT;
* check the log for success;

* 2.3. Inserting rows from a query list;
* It is the fastest way to insert rows of data;
* Can select data from one or more tables;
* After table creation and insertion is done, if any new rows added they get appended at the end;
PROC SQL;
	CREATE TABLE WORK.ACITIES2 like ACITIES;
	INSERT INTO WORK.ACITIES2 
	SELECT * from work.acities where code in('DEL','CHD','PUN');
QUIT;

* 2.4. Need to be careful while inserting DATE values; 
* Got to mention the classifier d for the date after the value;
PROC SQL;
	INSERT INTO work.discount
	values('MAS','12May2018'd,'12Jun2018'd,21)
	values('SBC','21Jul2018'd,'2Aug2018'd,31)
	values('KAR','01Oct2018'd,'9Nov2018'd,45);
QUIT;

* 3. Intergrity Constraint (IC);
* IC is used to:
	1. Maintain Validity 
	2. Consistency in data values;
* PROC DATASET can be used to add IC, but they can be used for existing tables/dataset;
* PROC SQL is used to create IC for new and existing tables;
* Can add intergrity constraint as part of column specification or even individualy as part of create table script;
* Can describe the constrains using DESCRIBE TABLE CONSTRAINT <table_name> will list all constraints associated with that table;
* There are generally 2 types of constrains in SAS PROC SQL:
	1. Generic IC - THese involve only one table
		1. CHECK - Contraint to ensure a value based-on/within a range or an expression 
		2. NOT NULL - Not allow missing values
		3. UNIQUE/DISTINCT - Not allow duplicate values and ensures values are unique
		4. PRIMARY KEY - Unique + NotNull, there can be only one PK for a given table
	2. Referential IC - These involves 2 tables
		5. REFERENCES - Define PK in one table and then define Forign key in second table and its action includes
			1. CASCADE - Update the Primary Key and do necessary changes to FK accordingly
			2. RESTRICT (default) - Doest allow PK to change instead through error
			3. SET NULL - Set the FK column as NULL;
* IC are only for tables and not for views;
* IC are applied only for newly created data that comes in and not for existing ones;
* There are 2 ways to create IC:
	3.1. Creating IC in a column specification;
	* CHECK(EXPR) - Col Value should satisfy this expression;
	* DISTINCT/UNIQUE - Col Value must be Unique;
	* NOT NULL - Col Value should not be NULL;
	* PRIMARY KEY - Col value must be unique and not null;
	* REFERENCE <TableName> <ON UPDATE/On DELETE> <IC Action>;
	*Table Name here is the table which has PK;
	* ON DELETE and ON UPDATE = These are triggering scenarios when referential action occurs;
	* Referential Action includes:
		CASCADE - Update PK and then update FK
		RESTRICT - This is the default, restrict update/delete when matching FK is already existing and through error
		SET NULL - SET all matching FK to NULL;
	* when an IC is created as part of Column specification then SAS will automatically name it;
	* default Index naming will be like _CKxxxx_, _FKxxxx_, _NMxxxx_, _PKxxxx_, _UNxxxx_ and counter begins from 0001;
* Creating a PRIMARY KEY and CHECK constraint using column specification;
PROC SQL;
	CREATE TABLE WORK.ACITIES3(
		city char(10) Primary Key,
		code char(3),
		name varchar(16),
		country char(8),
		price num check (price < 5000));
QUIT;

	* 3.2. Creating IC by using Constraint Specification - Standalone definition;
	* Standalone IC definition gives independence to name a Constraint;
	* Constraint can be applied on multiple columns at a time;
	* CONSTRAINT key word is used;
	* CONSTRAINT <constraint_name> <Constraint_type> <colum name or columns names where constraint needs to be applied>;
	* Composite primary key is supported in SAS but there can be only one Primary Key Constraint attached to a table;
	* Multiple columns can be defined only for below constraints:
		1. DISTICT
		2. UNIQUE
		3. PRIMARY KEY
		4. FOREIGN KEY;
	* To define FK we need to use REFERENCES key word;
	* MESSAGE= msg given here is broadcasted in SAS log when error in constraint occur, MAX string length is 250;
	* MSGTYPE= specifies how the message is displayed, there are two option NEWLINE|USER;
		* MSGTYPE=NEWLINE - Print both SAS Log and USER message declared in MESSAGE= in new lines;
		* MSGTYPE=USER - Print only the USER message given as part MESSAGE=;
PROC SQL;
	CREATE TABLE WORK.ACITIES3(
		city char(10),
		code char(3),
		name varchar(16),
		country char(8),
	constraint On_all_cols DISTINCT (city, code, name, country),
	constraint pk_city PRIMARY KEY (City, code));
QUIT;

* 4. UNDO_POLICY - This is like a ROLLBACK implementation of SAS;
* When there is a constraint and when one row in insert fails due to some IC, then whole insert from the table is rollbacked;
* If we wish to insert or update rows which PASS IC and ignore those have issues UNDO_POLICY should be declared in PROC SQL;
* There are 3 types in UNDO_POLICY they are:
	1. REQUIRED - This is the default, Perform a rollback if IC is not met even by one row, if rollback cannot be done reliable PROC SQL will not get executed and will throw error
	2. NONE - DATA which are good get updated or inserted and WARNING is thrown for those which get failed.
	3. OPTIONAL - Perform UNDO, if not possible then no UNDO is attempted;
* UNDO_POLICY do not work for data accessed through SAS/SHARE server and changes made through SAS/ACCESS servers;
* UNDO_POLICY stays for complete SAS session untill RESET is done on PROC SQL;
* UNDO_POLICY is an option to PROC SQL, whcih instruct what should happen when IC fails;
* Generally 2 NOTES are created in logs:
	Note1: Says which value stmt fails
	Note2: Talks about the effect of UNDO_POLICY in code;
PROC SQL undo_policy=none;
	CREATE TABLE WORK.ACITIES3(
		city char(10),
		code char(3),
		name varchar(16),
		country char(8),
	constraint On_all_cols DISTINCT (city, code, name, country),
	constraint pk_city PRIMARY KEY (City, code));
QUIT;
* Displaying the Constraints associated with tables;
* this is used to validate the table even before a new IC is created for a table;
PROC SQL;
	DESCRIBE TABLE CONSTRAINTS ACITIES3;
QUIT;

* 4.1. Updating the Rows in a table;
* UPDATE can be done only on the existing data;
* There are 2 ways to update the column:
	1. Updating all rows with same expression using single UPDATE stmt, use UPDATE - SET - WHERE
	2. Updating multiple rows with multiple conditions - UPDATE - SET - CASE - WHEN - THEN - ELSE - END;
* Remember there can be only one where clause for a given UPDATE statement;
* However, there can be multiple WHEN clause in a given UPDATE statement;
* 4.1. Updating ROWS by using same Expression;
* Without WHERE caluse the whole column will get updated to the value defined, so use WHERE carefully when needed;
PROC SQL;
	UPDATE WORK.ACITIES
	SET city='Bengaluru'
	WHERE code='SBC';
QUIT;

* 4.2. Updating ROWS by Different Expression;
* Method-1: can use multiple UPDATE - SET - WHERE statements;
PROC SQL;
	UPDATE WORK.ACITIES
	SET city='Bengaluru'
	WHERE code='SBC';
	UPDATE WORK.ACITIES
	SET city='Madras'
	WHERE code='MAS';
QUIT;
* Method-2: can use UPDATE - SET - CASE - WHEN - THEN - ELSE - END statement;
* One WHEN clause will return just one value only to the case statement, this value is accordingly used;
* CASE statement can be used in SELECT-UPDATE-INSERT;
* ELSE clause in CASE statement is optional but it is a good practice to use it, if you dont use else then non-matching columns will be updated with missing values;
* Below program update the table wrongly with missing values;
PROC SQL;
	UPDATE WORK.ACITIES
	SET CITY = 
	CASE (CODE)
		WHEN 'MAS' THEN 'Chennai'
		WHEN 'SBC' THEN 'Bangalore'
	END;
QUIT;
* Correcting it with else;
* CASE can also hold expression;
* CASE is used only when SET uses = operator, No other Comparitive operators can be used other than =;
PROC SQL;
	UPDATE WORK.ACITIES
	SET CITY = 
	CASE (CODE)
		WHEN 'MAS' THEN 'Chennai'
		WHEN 'SBC' THEN 'Bangalore'
		WHEN 'MBM' THEN 'Mumbai'
		WHEN 'DEL' THEN 'Delhi'
		WHEN 'PUN' THEN 'Pune'
		WHEN 'CHD' THEN 'Chandigarh'
		ELSE 'NAN'
	END;
QUIT;
* If CASE needs to be used with SELECT it must be used as a seperate Column Specification with an AS operator;

* 6. Deleting rows;
* Basic code is DELETE FROM <table_name> WHERE <Expression>;
* DELETE can be used for VIEW as well;
* View is used to provide a restrictive access;
* WHERE is used to DELETE only few subset of rows, to delete all rows in table remove where;
PROC SQL;
	DELETE FROM work.Acities 
	where code in ('MAS','SBC','MBM');
RUN;

* 7. Altering the Table;
* Used to alter the table structure;
* Can alter only tables and not views, this is because view is a shadow of tables;
* there are 3 operations:
	1. ADD - used to add new column, can specify one or more col definition
	2. DROP - can drop multiple col at a time until there is no IC, each col is seperated by ,
	3. MODIFY - can modify only column width and column modifier like LABEL, INFORMAT and FORMAT;
				* cannot typecast the datatype using MODIFY nor change the column name, for this used PROC DATASET - RENAME;
* These are not enclosed in ();
* Multiple col definition can be done by seperating each with ,;
PROC SQL;
	ALTER table ACITIES
		ADD price num,profit num
		modify code format=char22. city format=char22.
		drop country;
QUIT;

* 8. Droping the table;
PROC SQL;
	DROP table work.Acities2;
QUIT;

