/* This will cover the functions available in SAS and its usgae */
* abs - this function will take an input x and output the absolute vale of x;
DATA ABS_DATA;
	input a @@;
	b=abs(a);
	datalines;
1 -2 3 -45 76 -33 86 -567 -34 342
;

PROC PRINT;
	var a b;

RUN;
QUIT;
