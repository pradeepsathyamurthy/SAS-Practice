/* 
Author: Pradeep Sathyamurthy
Date: 09-May-2017
Chapter: 5 - Creating SAS Data Sets From Raw Data
*/

*SAS Dataset <-  Any external data read by SAS and get stored in a format which is convinient for SAS to process is called SAS dataset;

* There are 3 style of input through which SAS can read a data and form a SAS Dataset
1. List Style
2. Column Style
3. Formatted Style
We will concentrate more on the Column Style here as part of this chapeter;

* These are called Datastep Program;

* Steps Followed:
	1. Library Referenec
	2. File Name Referenc
	3. Data Statement
	4. Infile Statement
	5. Input Statement
	6. Run statement for execution ;

LIBNAME CH5_LIB 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH5_DATA'; * reference SAS Data Library, path mentioned must be a valid path else lib reference will not be created and throws error;
* libref must follow standard format can contain only [a-z0-9] and _ Also name cannot exceed more than 8 char in length;
FILENAME CH5_FILE 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH5_DATA'; * Referemce the external file - this is a temporary reference. However, FILENAME is GLOBAL as LIBNAME;
* File Name refence can be fully qualified name (till the file name -> 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH5_Practice\baylor-religion-survey-data-2007.txt';
* Or file name reference can be an aggregated storage location (Directory that contains multiple external files) -> 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH5_Practice';
* fileref must follow standard format can contain only [a-z0-9] and _ Also name cannot exceed more than 8 char in length;
DATA CH5_LIB.MARATHON_CHAP5;
	infile CH5_FILE('baylor-religion-survey-data-2007.txt');
	* infile CHAP5_FILEREF; /* <- if FILENAME ref is fully qualified style */
	* infile 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH5_Practice\baylor-religion-survey-data-2007.txt'; /* This is a Neive method used most */
	
	* Column Input Style - For Data to be in Column input style, they must be;
		* Standard Character/Numeric Value <- [A-Za-z][0-9][+-][.] there shouldn't be any special character or faction or binary or hexadecimal number;
		* Fixed Length <- Contains data which is arranged in column
		Column Style: [Standard Data + Well Ordered]
		1--------10---------20---------30--------40---------50---------60---------70---------80--------90
		124		61		Mod		Male          	Pradeep					United States
		123		76		Ded		Female      	Sruthi					India
		142		89		Reg		Male	     	Sathyamurthy			United Kingdom
		
		* Free format/Free Style <- Data which are not arranged in collumns		
		1--------10---------20---------30--------40---------50---------60---------70---------80--------90
		124	61	Mod	Male          Pradeep		United States
		123	76	Ded	Female      Sruthi		India
		142	89	Reg	Male	     Sathyamurthy	United Kingdom
	* as part of this chapter we will concentrate on only Column style input;
	
	* To descibe a data we need
		1. valid SAS Variable Name
		2. Type
		3. Range (starting and ending column);
	input 	ID 1-10	WEIGHT 11-16 REGION 17 RELIG1 18-19 RELIG2 20-21 DENOM $ 22-72; * files can be read in any order in this style;
	* input command is used to describe the data;
	* Whenever a column is a string needs to be described using $ symbol;
	* Whenever a column is a number it needs to be described just like that;
	* Range mentioned are nothing but Fixed length of a particular column from and till which a data gets streched to max;
	* Id. WEIGHT, REGION are nothing but the column names given;
RUN;
	
* Validate the data read;
PROC PRINT DATA=CH5_LIB.MARATHON_CHAP5;
RUN;

* Possible Errors:
	1. Data Entry Error - Invalid Data Entry (Char instead of Numeric or vice versa, but SAS will not stops its execution here)
	2. Sysntax Error - Error insyntax - SAS will stops its execution;

* Steps to be followed by experts in reading a external data file:
		1. Write DATA step using OBS in INFILE 
		2. Submit the DATA step
		3. Check Log 
		4. View and verify the resulting data
		5. Remove the OBS from INFILE and re-submit the DATA step
		6. Check the log again
		7. View and verify the resulting data again;

* Arithmatic Operators [Follows BODMAS rule]:
	- <- Negative Prefix/Subtraction
	** <- Exponentiation
	* <- Multiplication
	/ <- Division
	+ <- Addition

* Comparison Operator
	= or eq <- Equal to
	^= or ne <- Not Equal to
	> or gt <- greater than 
	< or lt <- less than
	>= or ge <- greater than equals
	<= or le <- less than equals

* Logical OPerators 
	AND or & <- All conditions true
	OR or | <- Atleast one condition true;

* In-stream data creation;
* Subsetting can be done using if statement;
DATA CH5_LIB.stress; * do not execute this peice, such dataset doesnt exist in my local;
	input ID Name $ RestHr MaxHR RecHR TimeMin TimeSec @@;
	TotalTime=(timemin*60)+timesec; *Shows how to create a new variable;
	resthr=resthr+(resthr*.10); *Even this is valid, stament in right processed first and then get assigned to left - check this;
	TestDate='01JAN2000'd; * This how we initialize the date constant';
	TestTime='09:25't; * This how we initialize the time constant';
	DateTime='18Jan2011:09:23:05'dt; * This how we initialize the datetime constant';
	if Name eq 'Prady' then CRR='A'; * <- This is called subsetting a data = Applying a filter and based on that creating a new variable;
datalines;
 1 	  Prady					2	1	2  3  2
 2	  Sruthi				3	2	3  4  3
;	*<- This is called null statement;
RUN; *<- No need of RUN command after mentioning NULL in above command, it is oprional. If you you RUN any commands between NULL and RUN will not be executed by SAS;

PROC PRINT DATA=CH5_LIB.stress;
RUN;

* Steps to create a RAW Data File
	1. Declare a _NULL_ data step (Opp to defining a SAS Data command)
	2. Set the SAS dataset from which we need to create a raw dataset (This is has no correlation with SAS dataset creation step)
	3. File name implication, that is imply where and what type of Data file needs to be created (This is like infile step)
	4. Use Put command to decide what collumns are needed in Raw data file (this is like input statement);

DATA _NULL_;
	set CH5_LIB.stress;
	file 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH5_Practice\stress_raw_data_out.txt';
	put ID Name $ RestHr MaxHR RecHR TimeMin TimeSec;
RUN;

* Keep command inside data step is used to subset the column globally;
