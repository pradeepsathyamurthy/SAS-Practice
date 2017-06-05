/* This will cover the functions available in SAS and its usage */
* abs - this function will take an input x and output the absolute vale of x;
DATA LENGTH_DATA;
	input a $CHAR30.;
	b=length(a);
	c=lengthn(a);
	d=lengthc(a);
	e=lengthm(a);
	datalines;
Pra deep Sathyamurthy
;

PROC PRINT;
	var a b c d e;

RUN;
QUIT;
