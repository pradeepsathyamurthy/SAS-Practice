/* This will cover the functions available in SAS and its usage */
* length - this function is used to find the length of a string;
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
