/* Chapter-6: Creating and Managing Indexes */
* Revision Time: 15 to 20 Mints;
* Index is used to Locate a row quickly and improve efficiency;
* It is like a book index;
* Index is an auxilary (suplimentry) file which stores the physical location of one or more column values;
* Multiple index can be created on a single table;
* However, one table can carry only one Index file;
* Index cannot be created on Views;
* Below is a simple index;
PROC SQL;
	CREATE TABLE work.Acities as
		select * from sasuser.acities;
	CREATE INDEX city
		on work.Acities(city);
	DESCRIBE TABLE ACITIES;
QUIT;

* 1. Understanding Index;
* Without index PORC SQL will access each row sequentially;
* Index = Value:Identifier pair;
* It stores UNique values of a column in ascending order and also stores the information about the location;
* This functionality allows PROC SQL to access a row directly by values;
* Using Index PORC SQL can access ROWS direcly;
* There are 2 types of Index:
	1. Smple Index - Index based on one column. Name of the column on which Simple index created will be the index name as well
	2. Composite Index - Index Based on more than one column. Composite Index name should be Unique, not an existing index or col names;
* Unique Index impose the Unique Integrity Constraints on indexing;
* Unique Index can be applied to both Simple and Composite Index;
* Below is a composite index;
* If a table already have duplicate values then SAS will not allow PROC SQL to create an index on that column;
* DESCRIBE TABLE <Table_Name> is used to refer the table structure and also index associated with it in a SAS Log;
PROC SQL;
	CREATE UNIQUE INDEX city_code
	on work.Acities(city, code);
	DESCRIBE TABLE ACITIES;
QUIT;
* Other alternatives to decribe a table are
	1. Dictionary.Index
	2. PROC CONTENTS
	3. PROC DATASET;

* 2. Deciding whether to create Index;
* Always weigh performance improvement over the cost and decide if index should be created or not;
* Remember that there is a cost associated with: Creating, Storing and Maintaining an index;

* 3. Very Important - Clauses which makes a good use of Index;
* Below clause performances can be improved with Index:
	3.1. WHERE - Using TRIM, SUBSTR, CONTAIN and LIKE makes a big use of any available index
	3.2. IN - This operator along with Subqueries makes big use of index
	3.3. CORRELATED Subqueries
	3.4. JOINS - Mainly equi joins makes big use of Index;

* 4. When are Index useful
	4.1. When the sample size we query for a table is small (15% of total table size)
	4.2. When Col references different values at a given time (I dont understand this point)
	4.2. When EquiJoin is performed without internal SORT
	4.3. Uniqueness can be enforced;

* 5. Cost of Using INdex
	5.1. Additional Memory
	5.2. Additional CPU time to create and maintain index
	5.3. Additional I/O
	5.4. Additional Disc space to store index file;

* 6. Guidelines to create Index
	6.1. Create less number of Index for a table
	6.2. Avoid creating index for smaller tables
	6.3. Avoid Index for low carnical columns (with low level of classes, e.g. GENDER has only Male/FEMALE)
	6.4. Avoid for queries that retreive small subset of Data
	6.5. Avoid creating Index more than once for a same column
	6.6. Do Benchmarking test to decide if index is really needed or not
	6.7. Performance of an Index can be improved by sorting a column before it is used for indexing
	6.8. Index live untill the Table is recreated and column on which index built is dropped
	6.9. You cannot create more than one simple index on a same column
	6.10. One Simple and One Composite Index can be created on a same column but it is useless
	6.11. Can create multiple index on same table with seperate create index statement
	6.12. All indexes of a table is stored in one Index file;

* 7. Index Usage
	7.1. SAS automatically decides whether to use index or not based on the resource usage
	7.2. To see if INDEX is being used by SAS set MSGLEVEL=I in OPTIONS
			MSGLEVEL=I - Displays Info along with Error, Warning and Notes, this is used for debugging
			MSGLEVEL=N - Display only Error, Warning and Notes, this is used for production;
OPTIONS MSGLEVEL=N;

* 8. Controlling INdex Usage
	IDXWHERE and IDXNAME are used to control Index Usage
	We can use either of these but not both at a same time
	8.1. IDXWHERE=YES - Insist SAS to use index irrespective to it being Productive or not
		 IDXWHERE=NO - Tell SAS to ignore all indexes and satisfy where condition by reading observations sequentially
		 These are mentioned at a place where index is potentially called, e.g. in the SELECT statement before WHERE clause
	8.2. IDXNAME =<INdex_Name> - Insist SAS to use that specific index irrespective to any other efficient index found by SAS itself;
PROC SQL;
	SELECT * 
	FROM work.ACITIES (IDXWHERE=YES)
	Where code='MBM';
	SELECT * 
	FROM work.ACITIES (IDXNAME=CITY)
	Where city='Mumbai';

* 9. Dropping an Index
	Use DROP INDEX <Index_name> FROM <table_name>;
PROC SQL;
	DROP INDEX city_code from work.acities;
	DESCRIBE TABLE work.acities;
QUIT;
