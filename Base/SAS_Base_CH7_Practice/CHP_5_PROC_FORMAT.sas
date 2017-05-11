/* User Defined FORMAT */
/* Here we will concentrate on how to create our own FORMAT style using PROC FORMAT*/

*Before going into User defined formatting let see how to use system FORMATS;
* Temporary system FORMAT behaviour;
DATA SAMPLE1;
	input Name $ Age Salary 15.0;
	datalines;
Pradeep	32	100000
Sruthi	23	150000
Gokul	27	75000
;

PROC Print DATA=SAMPLE1;
	format Salary Dollar15.0; * Associating format temporarily to variables;
RUN;

PROC Print DATA=SAMPLE1;
	 * Since Format in above statement was given in PROC PRINT it applies only local within that block;
RUN;

*Permanent System FORMAT behaviour;
DATA SAMPLE2;
	input Name $ Age Salary 15.0;
	format Salary Dollar15.0; * Associating format permanantly to the variables;
	datalines;
Pradeep	32	700000
Sruthi	23	750000
Gokul	27	175000
;

PROC Print DATA=SAMPLE2;
	* Since FORMAT is defined as part of the DATA statement it acts global until this SAS session exist;
RUN;


/* Invoking the USER Defined Library */
LIBNAME library 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH7_Practice'; * In live projects it is advisable to create your own folder for format anf define that in libname;
PROC FORMAT LIB=library FMTLIB; * FMTLIB <- list all the user defined format in the library or library catalog;
	* Remember, name of the format cannot end with a number;
	value firstfmt 
		101='Manager'
		102='Text Processor'
		103='Techincal Writer'
		104='Software Engineer'
		105='Data Scientist';
RUN;

DATA SAMPLE3;
	input Name $ Age Salary	Designation;
	format Designation firstfmt.; *.<- this period(.) will define it as a user defined format to system;
	datalines;
Pradeep	32	100000	101
Sruthi	23	150000	102
Gokul	27	75000	103
Jaya	34	300000	104
Sathya	56	800000	105
;

PROC PRINT DATA=SAMPLE3;
RUN;

/* Format can be defined of 3 types:
	1. Numeric Format
	2. Character Format 
	3. Range Format
	If we have more than one format to be defined we can do so using the multiple format definition */
LIBNAME library 'D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH7_Practice'; * In live projects it is advisable to create your own folder for format anf define that in libname;
PROC FORMAT LIB=library; * FMTLIB <- list all the user defined format in the library or library catalog;
	* Remember, name of the format cannot end with a number, secondfmt is the format name which will be store inside the catelog;
	value secondfmt 
		101='Manager'
		102='Text Processor'
		103='Techincal Writer'
		104='Software Engineer'
		105='Data Scientist';

	value $thirdfmt
		'A'='Good'
		'B'='Fair'
		'C'-'E'='Average'
		'F'='Poor';

	value fourfmt
		low-<13='Child'
		13-<20='teenager'
		20-<65='adult'
		65-high='senior citizen'
		other='unknown';
RUN;

DATA SAMPLE4;
	input Name $ Age Salary	Designation grade $ agegrp;
	format Designation secondfmt. grade $thirdfmt. agegrp fourfmt.; *.<- this period(.) will define it as a user defined format to system;
	datalines;
Pradeep	32	100000	101	A	10
Sruthi	23	150000	102	B	15
Gokul	27	75000	103	C	25
Jaya	34	300000	104	D	
Sathya	56	800000	105	E	68
;

PROC PRINT DATA=SAMPLE4;
RUN;

* Formats created can be deleted using the PROC CATALOG command;
* Formats created without library definition gets created in WORK directory which is temporary and exists only untill the SAS session exists;

