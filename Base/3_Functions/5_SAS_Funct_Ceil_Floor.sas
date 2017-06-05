/* This will cover the functions available in SAS and its usgae */
* ceil - convert a float to highest integer value;
* floor -convert a float to highest integer value;
DATA CEIL_DATA;
	input a @@;
	b=ceil(a);
	c=floor(a);
	datalines;
1.5 -2.4 3.1 -45.7 76.8 -33.9 86.2 -567.4 -34.6 342.3
;

PROC PRINT DATA=CEIL_DATA;
	var a b c;

RUN;
QUIT;
