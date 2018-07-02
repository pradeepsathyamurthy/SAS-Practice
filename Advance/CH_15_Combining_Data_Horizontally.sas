/* Pradeep Sathyamurthy */
/* June 2018 */
/* Ch-15 Combining Data Horizontally */

* 1. General OverView;
/* Here we will discuss about various tchnology used to join teo or more Dataset horizontally, they can be acheived in two ways:
	1. Using Dataset Match Merge
	2. Using PROC SQL Joins
IF-THEN-ELSE considtion can be used to impute the data or derive a new columns based on some condition
There are also scenarios where we need to join two or more dataset where there is no matching column with them.
We can even store the Summary statistics produces by PROC MEANS in a seperate dataset
How to use KEY and SET statement to combine two dataset are discussed
How to use index to combine two or more dataset is discussed
Usage of _IORC_ to determine wheather index search was successful was discussed
Use of UPDATE statement to update the MASTER dataset using the transactional dataset is disccussed */

* 2. Reviewing Terminologies;
/*  2.1. Combining Data Horizontally: Merging two or more dataset to form a single large dataset
	2.2. Performing a Table Lookup: Information retrival from auxilary sources, based on the value of a variable in primary sources
	2.3. Base Table: This is the Primary source of horizontal combination
	2.4. Lookup Table: All the input datasets other than the Base Table
	2.5. Key Variable(s): One or more variable that resides in both base and lookup tables
	2.6. Key Value(s): For each observations, it is the value for the key variable */
* Combing Data Horizontally and Performing Table lookup are one and the same;
* Dataset=Tables, Variables=Columns, Observations=Rows;
Data Base_Table;
	input Num VarA $;
	datalines;
1	A1
2	A2
3	A3
;
RUN;
Data Lookup_Table;
	input Num VarB $;
	datalines;
1	B1
2	B2
4	B3
;
RUN;
DATA merged_data;
	merge Base_Table Lookup_Table;
	by Num;
RUN;
PROC PRINT DATA=merged_data;
RUN;
QUIT;
* Dataset relationship can be classified into 4 types;
* 1. One to One Matching: matching Key values in both base and lookup tables are unique;
* 2. One to Many Matching: matching Key values in Base table is unique and lookup table is not Unique;
* 3. Many to Many Matching: matching Key values in Base table and lookup table are not Unique;
* 4. Non Matching: Keys that do not match anything, one of thw above 3 dataset relasionship also have Non-matching datasets;
	* 4.1. Dense Match: Nearly every observation in base table has a matching observation in lookup table, may be not 100% match;
	* 4.2. Sparse Match: there are more unmatched observation in either base or lookup tables;

* 3. Working with lookup values outside of SAS Dataset;
* This can be acheived in 3 ways: 1. Using IF-THEN-ELSE, 2. SAS Arrays, 3. SAS Formats;
* 3.1. IF-THEN-ELSE Statements;
* Use to combine SAS Dataset + External/Derived Values;
* In below program, we are trying to create or impute the new table find;
Data IFTHENELSE_COMBINED;
	set Merged_data;
	if VarA='A3' then find='Missing';
	else if VarB='B3' then find='Missing';
RUN;
PROC PRINT DATA =IFTHENELSE_COMBINED;
RUN;
QUIT;
* 3.2. SAS Arrays;
* These arrays generally hard code lookup values into the program or read them into the array from a dataset;
* 1. Hard Code lookup value into the program;
* 2. Read them into the array from a dataset;
* Memory requirement to load the whole array is the major drawback of this process;
* This technique is capable of returning only one value from the lookup operation;
* Study arrays from base cert and come here;
* 3.3. SAS Format;
* Use FORMAT in Data step or ATTRIB in PROC step;
* PUT Statement can be used along with FORMAT;
* Multiple FORMAT can be created and everything can be used in a same Data or Proc step;
* FORMAT proc require the entire format to load in the memory for a binary search whcih is a drawback;
PROC FORMAT;
	VALUE birthdate 1001 = '01Jan1963'
					1002 = '02Feb1964'
					1003 = '03Mar1964'
					1004 = '04Apr1964';
RUN;
DATA Temp_Format;
	input X Y;
	format x birthdate.;
	datalines;
1001	1
1002	2
1003	3
1004	4
;
RUN;
PROC PRINT DATA=Temp_Format;
RUN;
QUIT;

* 4. Combining Data with DATA step Match Merge Process;
* Here all datasets needs to be sorted or indexed based on the BY variable;
* MERGE Statement will return both matching and Nonmatching by default, use DATA step to return only the exact match;
* Not good for many-many match;
* Cartisian Product is not formed = Data is read sequentially, once read it is never re-read again;
* Since no CP, it is not a good way to work with many to many matching;
* Below e.g. try to merge SASUSER.Acities, SASUSER.Revenue, SASUSER.Expenses;
PROC PRINT DATA=SASUSER.ACITIES (obs=3);
RUN;
QUIT;
PROC PRINT DATA=SASUSER.REVENUE (OBS=3);
RUN;
QUIT;
PROC PRINT DATA=SASUSER.EXPENSES (OBS=3);
RUN;
QUIT;
* Let us first try to sort above 3 datasets before merging;
PROC SORT DATA=SASUSER.REVENUE;
by FLIGHTID DATE;
RUN;
PROC SORT DATA=SASUSER.EXPENSES;
by FLIGHTID DATE;
RUN;
* Now merging the 2 datasets with common BY variable;
DATA merged_temp;
	MERGE SASUSER.REVENUE SASUSER.EXPENSES;
	BY FLIGHTID DATE;
RUN;
* Above merge will cause issues and a warning is thrown, saying multiple length specified, this is because of many to many relation;
* to correct this we need to use IN variable along with IF condition;
DATA merged_temp1(drop=revlst revbusiness revecon expenses);
	MERGE SASUSER.REVENUE(in=R) SASUSER.EXPENSES(in=E);
	BY FLIGHTID DATE;
	if R and E;
		profit=sum(revlst,revbusiness,revecon, -expenses);
RUN;

PROC PRINT DATA=merged_temp (OBS=5);
RUN;
* Now we can merge merged_temp table with Acities based on BY var being Code and Dest respectively;
PROC SORT DATA=merged_temp1;
by code;
RUN;
PROC SORT DATA=SASUSER.ACITIES;
by DEST;
RUN;
DATA merged_final;
	merge work.merged_temp1 sasuser.acities;
	*BY code dest; * this will through error, because code is not in acities and dest is not in merged_temp;
	* We need to rename one of the column, we will better rename CODE to DEST;
	RENAME Code=dest;
RUN;
QUIT;

DATA merged_final1;
	merge work.merged_temp1 (in=M)
			sasuser.acities(in=A rename=(code=dest) keep=city name code);
	by dest;
	if A and M;
RUN;
QUIT;

PROC PRINT DATA=merged_final1;
RUN;
QUIT;

* 5. Using PROC SQL to join Data Horizontally;
* This is a PROC SQL implementation on above example;
* we are trying to merge 3 tables, ACITIES, REVENUE and EXPENSES to produce a new table called ALLData;
PROC SQL;
	CREATE TABLE WORK.ALLDATE as (
		SELECT R.DATE, R.Dest, R.FlightID, R.Origin, A.Name as DestAirport, A.City as DestCity, 
		(R.rev1st+R.revbusiness+R.revecon-E.expenses) as Profit 
		from SASUSER.ACITIES as A, SASUSER.REVENUE as R, SASUSER.EXPENSES as E
		WHERE (A.Code=R.Dest and R.flightid=E.flightid and R.date=E.date)
		);
QUIT;
PROC PRINT Data=work.alldate (OBS=5);
RUN;
QUIT;

* 6. Comparing Dataset Match Merge and Proc SQL Joins;
* It is possible to create identical result with both DATA match MERGE and PROC SQL;
* Although produce similar results, way it get process is different. However, one or the other is chosen based on the need and efficiency;
* 6.1 Data Step Match Merge
	Adv:
		1. Complex data step logic can be done to deal with complex dataset
		2. No limit on number of input dataset, concern is only the memory
		3. Multiple BY variable is possible to produce lookup based on more than one column
	Disadv:
		1. Dataset needs to be sorted everytime
		2. Cannot be used for many to many match as there is no cartisian product formation
		3. When merging BY variable must be present in all dataset being merged;
* 6.2 PROC SQL 
	Adv:
		1. No need to sort the dataset
		2. Multiple dataset can be merged without a common variable b/w them using cartisian product
		3. Flexibility to create dataset, views or just report based on need
	Disadv:
		1. Maximum number of table that can be joined in inner join is 32
		2. Complex business logic is difficult
		3. PROC SQL needs more resources comparitively;
* Always remember since PROC SQL works on cartisian product, there is a minimal to no chance of forming a missing value;
* 6.3. One to One Match - Both implementation produce identical results;
DATA Data1;
	input X Y $;
	datalines;
1 A
2 B
;
RUN;
DATA Data2;
	input X Z $;
	datalines;
1 F
2 G
;
RUN;
QUIT;
* let us do one to one matching directly as data seems sorted already;
DATA DATA3;
	merge data1 data2;
	by X;
RUN;
PROC PRINT DATA=DATA3 NOOBS;
RUN;
* PROC SQL Implementation will be the inner join;
PROC SQL;
	SELECT D1.X, Y, Z 
	from Data1 D1, Data2 D2
	where D1.X=D2.X;
QUIT;

* 6.4. One to Many Matching - Even this produce a Identical Results with both implementation;
DATA Data1;
	input X Y $;
	datalines;
1 A
2 B
;
RUN;
DATA Data2;
	input X Z $;
	datalines;
1 F
1 R
2 G
;
RUN;
QUIT;
* let us do one to many matching directly as data seems sorted already;
DATA DATA3;
	merge data1 data2;
	by X;
RUN;
PROC PRINT DATA=DATA3 NOOBS;
RUN;
* PROC SQL Implementation will be the inner join;
PROC SQL;
	SELECT D1.X, Y, Z 
	from Data1 D1, Data2 D2
	where D1.X=D2.X;
QUIT;

* 6.5. Many to Many Matching - Different result is produced by Data Step and Proc SQL;
DATA Data1;
	input X Y $;
	datalines;
1 A
1 C
2 B
;
RUN;
DATA Data2;
	input X Z $;
	datalines;
1 F
1 R
2 G
;
RUN;
QUIT;
* let us do many to many matching directly as data seems sorted already;
DATA DATA3;
	merge data1 data2;
	by X;
RUN;
PROC PRINT DATA=DATA3 NOOBS;
RUN;
* PROC SQL Implementation will be the inner join;
PROC SQL;
	SELECT D1.X, Y, Z 
	from Data1 D1, Data2 D2
	where D1.X=D2.X;
QUIT;

* 6.6. Non-Matching - Different result is produced by Data Step and Proc SQL;
DATA Data1;
	input X Y $;
	datalines;
1 A
2 B
3 C
;
RUN;
DATA Data2;
	input X Z $;
	datalines;
1 F
3 T
4 W
;
RUN;
QUIT;
* let us do non matching directly as data seems sorted already;
DATA DATA3;
	merge data1 data2;
	by X;
RUN;
PROC PRINT DATA=DATA3 NOOBS;
RUN;
* PROC SQL Implementation will be the inner join;
PROC SQL;
	SELECT D1.X, Y, Z 
	from Data1 D1, Data2 D2
	where D1.X=D2.X;
QUIT;

* 7. Very Important - Combining Summary Data and Detail Data;
* We will see how a summary statistics can be routed to form a new dataset;
* Acheived through some summary function like PROC MEANS, OUTPUT which will output/route the result to a SAS dataset and NOPRINT to suppress the PROC PRINT result;
* For every summary function procedure, 2 automatic variables are produced;
* 1. _TYPE_ = Contain the information about the class variable;
* 2. _FREQ_ = Contain the number of observation that an output level represents;
* In below e.g we compute the sum of all revcargo column from sasuser.monthsum dataset and store it in a sasdataset called work.summary;
* Method-1: Using Summary procedure and combining its results with a Data step;
PROC MEANS data=sasuser.monthsum noprint;
	var revcargo;
	output sum=Cargosum out = work.summary;
RUN;
PROC PRINT DATA=work.summary;
RUN;
QUIT;
* Now let us combine both summary and monthsu dataset to create a final dataset named Percent1;
* Here we use 2 different dataset, memory usage is more;
DATA Percent1;
	if _N_ = 1 then set work.summary(keep=cargosum);
	set sasuser.monthsum(keep=salemon revcargo);
	PctRev=revcargo/cargosum;
RUN;
PROC PRINT DATA=Percent1;
RUN;
QUIT;
* Method-2: Performing summary as part of dataset itself and merging with another dataset;
* Here we use same dataset but, we do twice, memory usage is less but performance might take a hit;
DATA Percent2;
	if _N_=1 then do until (lastobs);
		set sasuser.monthsum(keep=salemon revcargo) end=lastobs;
		TotalRevenue+revcargo;
	end;
	set sasuser.monthsum(keep=salemon revcargo)
	PctRev=revcargo/cargosum;
RUN;
QUIT;

* 8. Using Index to Combine Data;
* Index is a SAS Data structure to deal with large dataset and which are highly quearied by application or user;
* If there are two datasset, one with huge value and dataset2 with less value and if we need to merge dataset2 to dataset1;
* Index is the best way. Index an be built using PROC SQL CREATE INDEX or using Data step INDEX CREATE methods;
* These index are used to merge the data efficiently at some case, let us see how we do that;

* 8.1. KEY= ;
* Use this option with SET statement to choose the observation that matched with merging dataset;
* This can be used only with one to one matching dataset and can be used with lookup table of any size;
* When SAS encounters a SET statement with KEY =, it will look for a value to exist in PDV;
* let us say we have an index named flightdate in sale2000 dataset and the index is on FlightID and Flight Date;
* sample set command with key will be: SET sasuser.sale2000 key=flightdate;
* when we declare above statement, SAS will look for value to exist in flightid and flightdate column of PDV;
* Remember when we use KEY= option, we cannot use WHERE processing on it;
* Order in which SET statement declared below is very important, as it is the one which fills PDV first and KEY= picks from there;
DATA work.profit;
	set sasuser.dnunder;
	set sasuser.sale2000(keep=routeid flightid date rev1st revbusiness revecon revcargo) key=flightdate;
	profit = sum(rev1st, revbusiness, revecon, revcargo, - expenses);
RUN;
* 8.2. _IORC_ Variable;
* This is a automatic variable which is created when KEY= option is used with SET statement;
* _IORC_ is called as Input Output Return Code;
* If _IORC_ = 0, it means the index match is found;
* If _IORC_ != 0, it means there is no index match and there is a chance for Data Error;
* Whenever _IORC_ !=0, _ERROR_=1, you need to reset the _ERROR_ after we correct the Data;
* <Sample Program>;

* 9. Using Transactional Dataset;
* There is a Master table which is a main table and a transaction table which is a small but latest table;
* We always update values from Transaction table to Master table;
* UPDATE statement is used for the same;
* Only 2 datasets can be updated this way at a time;
* Datasets need to be sorted;
* Data in Master table must be unique for the BY variable;
* Always Master Dataset must be listed first in the UPDATE statement;
PROC SORT data=mylib.empmaster;
	BY empid;
RUN;
PROC SORT data=mylib.empchange;
	by empid;
RUN;
DATA mylib.empmaster;
	UPDATE mylib.empmaster mylib.empchanges;
	by empid;
RUN;


