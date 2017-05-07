/* This program showcase how to use output statement */

* Method-1;
DATA SUM_AVG;
	input x @@;
	datalines;
1 2 3 4 5 6 7 8 9 10
;

DATA _NULL_;
	file "c:/datasets/avg.txt";
	set SUM_AVG end=eof;
	count+1;
	sum+x;
	if eof then do;
	 avg=sum/count;
	 put "Average>>>" avg 10.3;
	end; 

DATA AVG_ANS;
	set SUM_AVG end=eof;
	count+1;
	sum+x;
	if eof then do;
	 avg=sum/count;
	end; 

PROC PRINT DATA=AVG_ANS;
	VAR x; 
	var avg;


* Method-2;
PROC MEANS mean DATA=SUM_AVG;
	output out=summary mean=avg;

DATA _NULL_;
	file "c:/datasets/avg1.txt";
	SET summary;
	put "Average::::" avg 10.3;

RUN;
QUIT;
