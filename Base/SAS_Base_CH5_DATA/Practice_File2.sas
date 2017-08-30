
DATA SAMPLE5;
	do i =1 to 5;
		i+1;
		output;
	end;
	output;
RUN;

PROC PRINT DATA=SAMPLE5;
RUN;

DATA SAMPLE6;
	do i =1 to 5 by 2;
		i+1;
		output;
	end;
	output;
RUN;

PROC PRINT DATA=SAMPLE6;
RUN;


DATA SAMPLE7;
	input id exp;
	datalines;
2542 100.00
3612 133.15
2198 234.34
2198 111.12
;

PROC SORT DATA=SAMPLE7;
	by (id exp) descending;
RUN;

PROC PRINT DATA=SAMPLE7;
RUN;


DATA SAMPLE8;
	length id $ 4; * This will throw error;
	set sample7;
RUN;


DATA SAMPLE9;
	input ID exp;
	datalines;
223 12
432 43
123 1
322 33
321 2
098 3
455 9
098 4
322 30
;

PROC SORT DATA=SAMPLE9 OUT=SAMPLE10;
	by ID;
RUN;

PROC SORT DATA=SAMPLE9 OUT=SAMPLE11;
	by ID exp;
RUN;

PROC SORT DATA=SAMPLE9 OUT=SAMPLE12;
	by descending ID exp;
RUN;

PROC SORT DATA=SAMPLE9 OUT=SAMPLE13;
	by ID descending exp;
RUN;

PROC PRINT DATA=SAMPLE13;
RUN;


DATA SAMPLE14 / debug;
	set sample9;
	if id=322;
	if exp=30;
RUN;

PROC PRINT DATA=SAMPLE14;
RUN;
