* PROC MEANS;
/*
This is the procedure used for descriptive statistics
It provides basic statistics about the dataset and have few options through which the output can be controlled
*/

DATA WORK.CARS_SAMPLE1;
	set SASHELP.CARS;
RUN;

PROC PRINT DATA=CARS_SAMPLE1 (OBS=10);
RUN;

*Default usage of PROC MEANS;
PROC MEANS DATA=CARS_SAMPLE1; 
/* <- By Default it produce below data:
	1. Variable/Column Names only for Numeric variable
	2. Label
	3. Record Count (Only the non-missing data count of an individual variable)
	4. Mean
	5. Standard Deviation
	6. Minimum
	7. Maximum
*/
RUN;

*Specifying the required statistics;
PROC MEANS DATA=CARS_SAMPLE1 MEAN MEDIAN RANGE; * <- Stats needed can be mentioned explicitly to print its result, default o/p gets suppressed;
RUN;

* Options that can be used to restrict the o/p in PROC MEANS;
PROC MEANS DATA=CARS_SAMPLE1 MEAN maxdec=2; * <- This will restrict the decimal point to 2;
	var MSRP Invoice EngineSize Cylinders Horsepower MPG_City MPG_Highway Wheelbase Length; *<- VAR is used to mention the variables for which the stats is required;
	class MAKE TYPE; *<- Provides statistics based on class levels of each variable mentioned, order plays a significant role; 
RUN;

PROC SORT DATA=CARS_SAMPLE1 out=CARS_SAMPLE2;
	by Make TYPE;
RUN;

PROC MEANS DATA=CARS_SAMPLE1 MEAN maxdec=2;
	var MSRP Invoice EngineSize Cylinders Horsepower MPG_City MPG_Highway Wheelbase Length; 
	by Make Type; *<- before using 'by' these variables needs to be sorted;
RUN;


 
