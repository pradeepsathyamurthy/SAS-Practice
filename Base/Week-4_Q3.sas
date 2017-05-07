* YoungerOlder Example with errors;
options pagesize=400 linesize=75;
DATA KIDS;
   infile "c:/datasets/kids.txt" firstobs=2;
   length name $13;
   input name $ gender $ age;
   if age < 10 then category = "Younger";
   else category = "Older";

PROC PRINT DATA=KIDS;

proc means data=kids noprint;
   where age < 9;
  output out=younger n=count_younger;

PROC PRINT DATA=YOUNGER;

proc means data=kids noprint;
   where age >= 10;
   output out=older n=count_older;

PROC PRINT DATA=OLDER;

PROC SORT DATA=KIDS;
	by category;
proc print;

data _null_;
   file 'c:/datasets/report.txt' print header=head;
   title "Report: Younger and Older Kids";
   if _n_ = 1 then set younger;
   if _n_ = 1 then set older;
   set KIDS end=eof;
   	by category;
   if first.category=1 or first.category=0 then do;
   put @5 name $13. @20 gender $1. @35 category $7.;
   end;
   return;
head:
   put "Count of Younger Kids:"  count_younger;
   put "Count of Older Kids:"  count_older /;
   put @5 "Name" @20 "Gender" @35 "Category";
   put @5 "=============" @20 "======" @35 "========";

run; 
quit;
