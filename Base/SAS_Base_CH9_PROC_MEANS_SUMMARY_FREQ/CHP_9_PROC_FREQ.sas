* PORC FREQ;
* This PROCEDURE is mainly for categorical variables;
* This is used whereever we need to have count based statistics;

DATA WORK.CARS_SAMPLE1;
	set SASHELP.CARS;
RUN;

PROC PRINT DATA=CARS_SAMPLE1 (OBS=10);
RUN;

* Framing a frequency table based on one categorical variable;
PROC FREQ DATA=CARS_SAMPLE1;
	tables TYPE;
RUN;

* Two way table;
PROC FREQ DATA=CARS_SAMPLE1;
	tables MAKE * TYPE;
RUN;

* Frequency table with 3 categorical variables variables;
PROC FREQ DATA=CARS_SAMPLE1;
	tables ORIGIN * MAKE * TYPE;
RUN;
