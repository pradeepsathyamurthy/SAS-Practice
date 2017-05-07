/* This will cover the functions available in SAS and its usage */
* abs - this function will take an input x and output the absolute vale of x;
DATA LENGTH_DATA;
	input a $10.;
	b=length(a);
	datalines;
Pradeep
;

PROC PRINT;
	var a b;

RUN;
QUIT;
