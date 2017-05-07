/* Reading from permanent SAS datasets */
/* we can declace library name and then start using the dataset inside it or use set command to create a local copy*/

* Example PermDS 
  Read SAS permanent dataset kids in the folder 
  first_grade;

options linesize=70 noprint pageno=1;
libname grade_1 'C:\datasets\Sample_SaS_Perm_Dataset';

proc print data=grade_1.kids; * Time taken to print this will be comparitively high when compare to temporary SAS datasets;

DATA GRADE_1_TEMP;
	set grade_1.kids; * This will create a local copy/ temporary SAS dataset in work library;

PROC print data=GRADE_1_TEMP;
run;
quit;
