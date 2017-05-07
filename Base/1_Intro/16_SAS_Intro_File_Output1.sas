DATA QUIZ3_1;
	input x @@;
	datalines;
1 2 3 4 5 6 7 8 9 10
;

PROC MEANS noprint;
	output n=num_observ mean=mean_val;

PROC PRINT;
	var num_observ mean_val;

RUN;
QUIT;


