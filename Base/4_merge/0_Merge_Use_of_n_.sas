/* Including Summary statistic done through PROC step in other datasets and usage of _n_ variable for the same */

* use _n_ and set command;
* _n_ is the observation number from the input statement;
* Leading and Trailing underscore means special SAS variables;

/*

Two automatic variables are created by every DATA step: _N_ and _ERROR_. 
_N_ is initially set to 1. Each time the DATA step loops past the DATA statement, the variable _N_ increments by 1. 
The value of _N_ represents the number of times the DATA step has iterated.

_ERROR_ is 0 by default but is set to 1 whenever an error is encountered, such as an input data error, a conversion error, 
or a math error, as in division by 0 or a floating point overflow. You can use the value of this variable to help locate 
errors in data records and to print an error message to the SAS log.
For example, either of the two following statements writes to the SAS log, during each iteration of the DATA step, 
the contents of an input record in which an input error is encountered: 

*/

* InsertSum Example
  Insert a summary statistic computed by proc means 
  or other proc into a dataset;

options ls=64 nodate pageno=1;

*Definig the dataset with two variables;
data original;
   input region $ store_count;
   datalines;
East  543
North 245
South 354
West  456
;

*Using the Proc means to compute aggregated calculations but not printing them here;
proc means data=original noprint;
   output out=summary sum=total;

* Trying to print the original dataset;
proc print data=original;

* Trying to print the summary dataset;
proc print data=summary;

* Using the summary generated through PROC MEANS step in a different dataset ;
data augmented;
   if _n_ = 1 then set summary; * This statement will be executed just once in this data loop iteration, so summary data always stays in tact;
   * if _n_=1 is not present, then on second iteration of data loop, SAS will search for the second record in Summary dataset;
   * However, summary has only 1 records n no 2nd observation it will cause program to hault even without executing further steps;
   * So we are just trying to execute this summary dataset once and have it in RAM for further usage;
   set original; * calling the whole dataset here;
   percent = 100 * store_count / total; *using the ststs calculated in summary datset here for finding average;
   keep region store_count percent; * Having only the necessary values as part of augmented dataset;

proc print data=augmented;
   format percent 5.2; * Printing the result of augmented dataset by formatting a variable;

run;
quit;
