data sample1;
	input sid mark;
	datalines;
1 100
2 90
3 30
4 50
5 60
;

data sample2;
	input sid mark1 mark2;
	datalines;
1 90 80
2 80 76
3 75 23
4 62 42
5 71 43
;

PROC PRINT DATA=sample1;
PROC PRINT DATA=sample2;

DATA MERGED;
	merge sample1 sample2;
		by sid;

PROC PRINT DATA=MERGED;

RUN;
QUIT;


