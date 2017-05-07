/* This program explain how to write a simple report like file to disc */
* Sales Example Write a report that totals sales from various cities;

* options is used to set the linesize, pagesize, etc., which will customize the output window of SAS;
* this is needed because if we have to write data to ROM we need them in single page instead of break;
* option with pagesiz can be used to display all records in single page;
options linesize=75 nodate pageno=1;

data sales;
   infile 'c:/datasets/sales.txt' firstobs=2;
   input city $ 1-11 sales;
   title 'Sales Example';

proc print;

proc sort;
   by city;

data _null_;
   file 'c:/datasets/report.txt' print header=head;
   title 'Sales Example';
   * This is a very important command to group by data in a column;
   * this can be used only with in _null_ data block and not in any proc methods;
   * end is used to identify if the last row is reached, since there is no boolean operator, we have value either 0 or 1;
   set sales end=eof;
      by city;
   * When you use set system will automatically create 2 variables last. and first. based on the column sorted;
   * if a column is not sorted we will not be able to use first. and last. value. and this value is applied on sorted variable;
   * I am not able to understand how if statement works, ask prof or look for week2 topics;
   if first.city then salestot = 0;
   salestot + sales;
   if last.city then do;
      grandtot + salestot;
      put @10 city @33 salestot DOLLAR8.;
   end;
   if eof then do;
      put @10 '-------------------------------';
      put @10 'Grand Total:' @31 grandtot DOLLAR10.;
   end;
   return;   
head:
   put //;                     
   put @10 'Region' @30 'Total Sales';
   put @10 '======' @30 '===========';

run;
quit;
