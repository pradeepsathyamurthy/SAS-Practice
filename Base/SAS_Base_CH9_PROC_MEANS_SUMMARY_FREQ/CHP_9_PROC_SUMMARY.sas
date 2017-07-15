* PROC SUMMARY;
* This is same as PROC MEANS;
* The difference between PROC MEANS and PROC SUMMARY is the that:
* PROC MEANS by default print the statistical report on execution and to stop it we need to use NOPRINT;
* However, in case of PROC SUMMARY, the statisticall output is suppresses and to make it print we need to use PRINT statement;

DATA WORK.CARS_SAMPLE1;
	set SASHELP.CARS;
RUN;

PROC PRINT DATA=CARS_SAMPLE1 (OBS=10);
RUN;

PROC SUMMARY DATA=CARS_SAMPLE1; *<- SAS will expect a PRINT statement here to display the result explicitly;
RUN;

* Using the PORC SUMMARY;
PROC SUMMARY DATA=CARS_SAMPLE1 PRINT; * <- This will print the default statistic whcih is nothing but the count of observations ;
* It prints only he number of observation because no variables on which stats needs to be applied is not mentioned;
RUN;

* Providing SUMMARY statistics, this same as what used for PROC MEANS;
PROC SUMMARY DATA=CARS_SAMPLE1 PRINT; 
VAR MSRP Invoice EngineSize Cylinders Horsepower MPG_City MPG_Highway Wheelbase Length; *<- This will print the summary stats for all these variables;
class TYPE;
output mean=MSRP Length out=CARS_STATS_SUMMARY;
RUN;
