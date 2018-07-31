/* Chapter-4: Combine Table Vertically */
* Revision Time: 30 to 35 mints;
* When we want to join two or more dataset horizontally we make use of SQL JOINS or Data Step Match Merge;
* However, if we need to join two or more dataset vertically PROC SQL's SET operators are most efficient;
* Before we dig in let us create a sample data that will be used in this chapter;

* Important SET oprations which might need multiple rivision;
* 1. INTERSECT + ALL + CORR - Remember the element mapping is one to one;
* 2. UNION + ALL - this is just nothing but stacking, remember there is no sorting here;
* 3. UNION + ALL + CORR - this is also stacking with overlay by name, remember there is no sorting even here;
* 4. OUTER UNION + CORR - remember there is overlay only on matching names, non-matching names still exists as part of final dataset and remember there is no sorting;

/* Sample Data Creation */
DATA One;
	input X A $;
	datalines;
1 a
1 a
1 b
2 c
3 v
4 e
6 g
;
DATA Two;
	input X B $;
	datalines;
1 x
2 y
3 z
3 v
5 w
;
DATA Three;
	input X C $;
	datalines;
5 x
1 y
3 z
2 v
5 w
;
PROC PRINT DATA=ONE;
RUN;
PROC PRINT DATA=TWO;
RUN;
PROC PRINT DATA=THREE;
RUN;
QUIT;

/* 1. Understanding SET Operation */
* SET operation is used to join two or more tables vertically;
* These are comparitively efficient when compare to other SAS SET methods;
* SET Operator goes between two select statement;
* SET statements can also be used to form a virtual queary that be used to temporarily fetch data;
* There are 4 main SET operators in PROC SQL;
* 	1. EXCEPT - Produce Unique record from table1 whose data are not in table2 and overlay by position
	2. INTERSECT - Produce Unique records whose data are common between table1 and table2, it also overlay columns by position
	3. UNION - Produce all Unique records from table 1 and table2, overlays based on position
	4. OUTER UNION - Produce all recrods from table1 and table 2 and doesnt overlay the columns;
* Generally PROC SQL which has SET operator have 2 passes;
* 	1. To Remove duplication 
* 	2. TO look for overlay;
* In addition to this there are 2 SET parameters called as:
	1. ALL - Allows duplicate records to list, This will make PROC SQL's SET operation to be one pass internally and effficient
	2. CORR (CORRESPONDING) - Make column overlay based on Column name instead of Column position;
* ALL and CORR can be used individually or even together based on the set operation we like to build;

/* 2. EXCEPT set operator */
* Set operator like EXCEPT overlay column by default, it is not necesary both tables should have same number of rows or same column names;
* Column from Table-1 overlays the column in Table-2, if there is column name defined in table-1 it is used, else column name from table-2 is used;
* Remember this is a whole large select statement, semicolon comes only after all select statement with set operator is defined;
PROC SQL;
	SELECT * from One
	EXCEPT
	SELECT * from two;
QUIT;
* Generally the dataset is  filtered, Sorted and then duplicates are removed and then overlay is done;
PROC SQL;
	SELECT * from Three
	EXCEPT
	SELECT * from two;
QUIT;

/* 2.1. EXCEPT with ALL operator */
* ALL will allow duplicate records to list by making the PROC SQL's SET operator as One Pass;
PROC SQL;
	SELECT * from One
	EXCEPT ALL
	SELECT * from two;
QUIT;

/* 2.2. EXCEPT with CORR operator */
* CORR or corresponding operator is used to overlay the column based on Column name and not position;
* Remember, overlaying by column position is default;
PROC SQL;
	SELECT * from One
	EXCEPT CORR
	SELECT * from two;
QUIT;

/* 2.2. EXCEPT with both ALL + CORR operator */
* Be very careful with this ALL + CORR operator output, try to understand well;
* Search here is observation wise and hence for below queary we get 1 1 4 6, these 2 ones are from dataset ONE which has no correspondence with dataset Two;
* ALL will allow duplicate;
* CORR or corresponding operator is used to overlay the column based on Column name and not position;
* Duplicate with overlaying based on column name occurs;
PROC SQL;
	SELECT * from One
	EXCEPT ALL CORR
	SELECT * from two;
QUIT;

* Printing the necessary dataset;
PROC PRINT DATA=ONE;
RUN;
PROC PRINT DATA=TWO;
RUN;
QUIT;

/* 3. INTERSECT set operator */
* This list data which are common between Table1 and Table2;
PROC SQL;
	SELECT * from One
	INTERSECT
	SELECT * from Two;
QUIT;

/* 3.1. INTERSECT with ALL operator */
* Remember it is INTERSECT and not intercept - this is a common error;
* ALL will allow duplicate records to list by making the PROC SQL's SET operator as One Pass;
PROC SQL;
	SELECT * from One
	INTERSECT ALL
	SELECT * from two;
QUIT;

/* 3.2. INTERSECT with CORR operator */
* CORR or corresponding operator is used to overlay the column based on Column name and not position;
* Remember, overlaying by column position is default;
PROC SQL;
	SELECT * from One
	INTERSECT CORR
	SELECT * from two;
QUIT;

/* 3.3. INTERSECT with both ALL + CORR operator */
* Always it is one to one mapping between two sets unless it is Union or Outer Union;
* Be very careful with this ALL + CORR operator output, try to understand well;
* ALL will allow duplicate;
* CORR or corresponding operator is used to overlay the column based on Column name and not position;
* Duplicate with overlaying based on column name using one to one mapping of each element occurs here;
PROC SQL;
	SELECT * from One
	INTERSECT ALL CORR
	SELECT * from two;
QUIT;

* Printing the necessary dataset;
PROC PRINT DATA=ONE;
RUN;
PROC PRINT DATA=TWO;
RUN;
PROC PRINT DATA=THREE;
RUN;
QUIT;

/* 4. UNION set operator */
* This is all unique rows from table1 and table2;
* This is very important to understand - Tables are concatenated + Sorted + Duplicates Removed + Overlay;
PROC SQL;
	SELECT * from One
	UNION
	SELECT * from Two;
QUIT;

/* 4.1. UNION with ALL operator */
* This is quite tricky;
* ALL will allow duplicate records to list by making the PROC SQL's SET operator as One Pass;
* Here Tables are just concatenated, they are not sorted;
PROC SQL;
	SELECT * from Three
	UNION ALL
	SELECT * from two;
QUIT;

/* 4.2. Union with CORR operator */
* CORR or corresponding operator is used to overlay the column based on Column name and not position;
* Remember, overlaying by column position is default;
* Concatenated + Sorted + Overlaid based on position;
PROC SQL;
	SELECT * from One
	UNION CORR
	SELECT * from two;
QUIT;

/* 4.3. UNION with both ALL + CORR operator */
* Be very careful with this ALL + CORR operator output, try to understand well;
* ALL will allow duplicate;
* CORR or corresponding operator is used to overlay the column based on Column name and not position;
* Duplicate with overlaying based on column name occurs;
* No Sorting here;
PROC SQL;
	SELECT * from One
	UNION ALL CORR
	SELECT * from two;
QUIT;

/* 4.4. Union OPerator with Summary function */
* Simple summary function in a select statement;
PROC SQL;
	SELECT sum(pointsearned) format=comma12. label='Total Points Earned',
			sum(pointsused) format=comma12. label='Total Points Used',
			sum(milestraveled) format=comma12. label='Total Miles Travelled'
	from sasuser.frequentflyers;
QUIT;
* If we want to diaply above results vertically;
* Need to use Union operator;
PROC SQL;
	SELECT 'Total Points Earned', sum(pointsearned) format=comma12. from sasuser.frequentflyers
	UNION
	SELECT 'Total Points Used', sum(pointsused) format=comma12. from sasuser.frequentflyers
	UNION
	SELECT 'Total Miles Travelled', sum(milestraveled) format=comma12. from sasuser.frequentflyers;
QUIT;

* Printing the dataset for reference;
PROC PRINT DATA=ONE;
RUN;
PROC PRINT DATA=TWO;
RUN;
PROC PRINT DATA=THREE;
RUN;
QUIT;

/* 5. OUTER UNION set operator */
* Tricky one;
* These are all rows from table1 and all rows from table2;
* There is no overlay of columns here and even duplicates are allowed;
* First table one and then Table2 data occurs, it leads to many missing values in data;
PROC SQL;
	SELECT * from One
	OUTER UNION 
	SELECT * from Two;
QUIT;

/* 5.1. OUTER UNION ALL set operator - For Outer Union there is no ALL operator*/
* Below PROC SQL will through error as ALL is used with OUTER UNION, there is no such implementation;
PROC SQL;
	SELECT * from One
	OUTER UNION ALL
	SELECT * from Two;
QUIT;

/* 5.2. OUTER UNION CORR */
* Overlays column based on Column name and also has other columns which are not matching;
PROC SQL;
	SELECT * from One
	OUTER UNION CORR
	SELECT * from Two;
QUIT;

/* 5.3. OUTER UNION ALL + CORR */
* Since there is no ALL implementation for OUTER JOIN, we cannot use this;
* Below code will produce error;
PROC SQL;
	SELECT * from One
	OUTER UNION CORR ALL
	SELECT * from Two;
QUIT;
