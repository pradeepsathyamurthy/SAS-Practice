/* Match Merging the dataset using a common variable - use merge command to do this */

* MatchMerge Example
  Merge a dataset of bolt orders with catalog 
  information to compute the extended price for each order;

options ls=64 nodate pageno=1;

data bolts;
   infile 'c:/datasets/bolts-coarse.txt' firstobs=2;
   input cat_no $ size diam length price;

proc print data=bolts;

data orders;
   input order_no customer $ cat_no $ quantity;
   datalines;
456 Miller   C421  32 
467 Jones    C531  41
531 Smith    C421  18
598 Roberts  C331  50
;

proc sort data=orders;
   by cat_no; * Data needs to be sorted before doing the match merge;

proc print data=orders;

data merged;
   merge orders bolts; * merge is the key-word used for the same;
      by cat_no; * merge should be done based on a common variable name;
   if order_no ~= .;
   ext_price = quantity * price;
   keep order_no customer cat_no quantity price ext_price;

proc print data=merged;

run;
quit;
