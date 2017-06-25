/* Combing SAS Datasets is the focus in this chapter */
/* This to know includes:
1. One to One Reading - overwrite  of datasets - Multiple SET statement - No Missing Values - Values are skipped
2. Concatenating - Overlap of dataset one above the other - Single SET statement - Missing Values - No Values skipped
3. Interleaving - Mutiple Mathching Observation for a unique value mentioned in BY - Single SET statement - No Missing Value - No Values Skipped
4. Match Merging - One matching observation for a unique value mentioned in BY - Single MERGE statement - Missing Values - No Values skipped
How to rename a variable using RENAME?
How to create and use temporary IN variable?
How to use DROP= and KEEP= while merging datasets? */

* Creating some sample DATA SETS;
DATA WORK.A;
	input Num VarA $CHAR.;
	datalines;
1 A1
3 A2
5 A3
;
RUN;

DATA WORK.B;
	input Num VarB $CHAR.;
	datalines;
2 B1
4 B2
;
RUN;

DATA WORK.C;
	input Num VarC $CHAR.;
	datalines;
1 C1
3 C2
5 C3
;
RUN;

DATA WORK.D;
	input Num VarC $CHAR.;
	datalines;
1 D1
3 D2
5 D3
;
RUN;

* 1. One to One Reading - overwrite  of datasets - Multiple SET statement - No Missing Values - Values are skipped;
* its like adding color above a color, that is one will overwite other;
* Important thing to note is number of observation in new dataset is equal to the number of observation in the smallest original dataset;
DATA DATA_ONE_To_One_Case1; * In this case data gets overwritten by the last dataset due to the presence of common variable;
	SET C;
	SET D;
RUN;

DATA DATA_ONE_To_One_Case2; * In this case data doesn't gets overwritten by the last dataset due to the absence of common variable;
	SET A;
	SET C;
RUN;

DATA DATA_ONE_To_One_Case3; * number of observation in new dataset is equal to the number of observation in the smallest original dataset;
	SET A;
	SET B;
RUN;

PROC PRINT DATA = DATA_ONE_To_One_Case1;
PROC PRINT DATA = DATA_ONE_To_One_Case2;
PROC PRINT DATA = DATA_ONE_To_One_Case3;
RUN;

* 2. Concatenating - Overlap of dataset one above the other - Single SET statement - Missing Values - No Values skipped;
* This is like a sandwidge, one data set sit below the other in a stacked fasion;
* Thus all observation are present in file data set, however when diffrent variabels in place we could see missing values;
* Type of common variables should be the same, else SAS throw error;
* If no explicit mention of Type, Label, format or informats are made, SAS will autmatically derive them from first occuring dataset;
DATA DATA_Concatenate_Case1;
	SET A B C D;
RUN;
PROC PRINT DATA = DATA_Concatenate_Case1;
RUN;

* 3. Interleaving - Mutiple Mathching Observation for a unique value mentioned in BY - Single SET statement - No Missing Value - No Values Skipped;
* This is like a reveat, just join two data set with a common variable, it is a union of multiple dataset;
* Thus provides multiple matching observation for a single observation in BY statement;
* Data read based on the order of By Variables defined
PROC SORT DATA = A;
	BY NUM;
PROC SORT DATA = B;
	BY NUM;
PROC SORT DATA = C;
	BY NUM;
PROC SORT DATA = D;
	BY NUM;

DATA DATA_Interleave_Case1;
	SET A C D;
	by NUM;
RUN;

DATA DATA_Interleave_Case2;
	SET A B C D;
	by NUM;
RUN;
PROC PRINT DATA=DATA_Interleave_Case1;
PROC PRINT DATA=DATA_Interleave_Case2;
RUN;

* 4. Match Merging - One matching observation for a unique value mentioned in BY - Single MERGE statement - Missing Values - No Values skipped;
* Simple Match Merging;
* Important thing to be noted is the PDV will retain its value untill the value for all BY variables changes;
DATA DATA_SIMPLE_MATCH_MERGE_CASE1;
	MERGE A B;
	BY NUM;
RUN;

* 4.1. Diff between Concatenation and Simple Merge: Doesnt stops its iteration wrt the smaller dataset, loop extends to the maximum observations;
DATA DATA_SIMPLE_MATCH_MERGE_CASE2;
	MERGE A B;
RUN;

DATA DATA_SIMPLE_MATCH_MERGE_CASE3;
	MERGE A C;
	by Num;
RUN;

DATA DATA_SIMPLE_MATCH_MERGE_CASE4;
	MERGE C D;
RUN;

PROC PRINT DATA = DATA_SIMPLE_MATCH_MERGE_CASE1;
PROC PRINT DATA = DATA_SIMPLE_MATCH_MERGE_CASE2;
PROC PRINT DATA = DATA_SIMPLE_MATCH_MERGE_CASE3;
PROC PRINT DATA = DATA_SIMPLE_MATCH_MERGE_CASE4;
RUN;

* Order of Sorting can be changed to decending by mentioning DECENDING after BY Statement;
* It must be done in all PROC SORT steps and as well in merge statement accordingly;
PROC SORT DATA = A;
	BY DECENDING NUM;
PROC SORT DATA = C;
	BY DECENDING NUM;
DATA DATA_MATCH_MERGE_DESCENDING;
	MERGE A C;
	by DESCENDING Num;
RUN;
PROC PRINT DATA=DATA_MATCH_MERGE_DESCENDING;
RUN;

* RENAME;
* In case any two dataset has same column name, SAS will overwrite the data with the latest data it encounters;
* In order to prevent this we can rename the matching variables using RENAME while defining the dataset in MERGE statement;
PROC SORT DATA=CLINIC.CAP2000;
	by FlightID;
RUN;

PROC SORT DATA=CLINIC.CAP2001;
	by FlightID;
RUN;

DATA MERGE_WITHOUT_RENAME;
	MERGE clinic.cap2000 clinic.cap2001 ;
	by FlightID;
RUN;

DATA MERGE_WITH_RENAME;
	MERGE clinic.cap2000 (rename= (date=Date_2000))
			clinic.cap2001 (rename=(date=Date_2001));
	by FlightID;
RUN;

PROC PRINT DATA=MERGE_WITHOUT_RENAME;
PROC PRINT DATA=MERGE_WITH_RENAME;
RUN;

* IN;
* This is a temporary variable, which is used to merge data only with matching values of BY variable;
PROC SORT DATA=CLINIC.CAP2000;
	by FlightID;
RUN;

PROC SORT DATA=CLINIC.CAP2001;
	by FlightID;
RUN;

DATA MERGE_WITH_IN;
	MERGE clinic.cap2000 (in=in2000 rename= (date=Date_2000))
			clinic.cap2001 (in=in2001 rename=(date=Date_2001));
	by FlightID;
	if in2000=1 and in2001=1;
RUN;

PROC PRINT DATA=MERGE_WITH_IN;
RUN;

* drop/keep;
* first. / last.;
