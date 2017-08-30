DATA SAMPLEE1;
	input tens;
	retain count 100;
	count+tens;
	datalines;
10
20
.
40
50
;
RUN;

PROC PRINT DATA=SAMPLEE1;
RUN;

DATA SAMPLEE2;
	NAME= 'Pradeep Kumar Sathyamurthy';
	Las_Name = upcase(scan(Name,-1));
	Mid_Name = scan(Name,-2);
	Name like '%Kumar%';
RUN;

PROC PRINT DATA=SAMPLEE2;
RUN;

data work.invest / debug;
	do year=2002 to 2016;
		Capital+5000;
		capital+(capital*.10);
		output;
	end;
run;

PROC PRINT DATA=work.invest;
RUN;

data work.staff;
	JobCategory = 'FA';
	output;
	JobLevel = '1';
	output;
	JobCategory1 = JobCategory || JobLevel;
	output;
run;

PROC PRINT DATA= work.staff;
RUN;

data test;
	input @1 date mmddyy10.;
	if date = '01JAN2000'd then event = 'January 1st';
	datalines;
01012000
;
run;

data avg22;
	avg1 = mean(1 2 3 4);
run;

proc print data=avg22;
run;

data work.pieces;
	do n=1 to 5;
	n+1;
	end;
run;

PROC PRINT DATA=work.pieces;
RUN;

data work.pieces1;
	do while (n lt 6);
	n+1;
	end;
run;

PROC PRINT DATA=work.pieces1;
RUN;

data work.pieces1;
	do until (n lt 6);
	n+1;
	end;
run;

PROC PRINT DATA=work.pieces1;
RUN;

DATA SAMP;
	retain temp 100;
	temp+1;
	output;
RUN;

PROC PRINT DATA=SAMP;
RUN;

