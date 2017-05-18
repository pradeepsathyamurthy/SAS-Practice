* PROC REPORT;

DATA WORK.CARS_SAMPLE;
	set SASHELP.CARS;
	keep Make Model Type Origin MSRP Cylinders;
RUN;

*PROC PRINT DATA=CARS_SAMPLE;
*RUN;

/* 
Need for this when we have PROC PRINT is:
1. This is a dedicated report writing tool in SAS
2. Can write Custom reports
3. Do seperate subtotals and grand totals
4. create and store report definitions
5. Observation column will not be displayed here

*/

PROC REPORT DATA=CARS_SAMPLE NOWD; * <- NOWD will not invoke a new report session, if WD is used a new report window will be invoked; 
RUN;

* Subsetting the column required;
PROC REPORT DATA=CARS_SAMPLE NOWD;
	column MSRP Make MSRP; * <- COLUMN command is used, it is scoped local, if subsetting needs to be done in data level KEEP is used;
	* Order mentioned above is followed in tact and even the column duplication is allowed;
RUN;

* Data Filtering using where;
PROC REPORT DATA=CARS_SAMPLE NOWD;
	column MAKE MSRP;
	where MSRP > 30000; * <- where is used to filter the data a column needs to display;
RUN;

