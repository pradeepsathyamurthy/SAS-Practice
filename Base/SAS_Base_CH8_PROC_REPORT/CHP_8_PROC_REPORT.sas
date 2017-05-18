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
4. create and store report definitions (formats, column spacing & justification, heading and order)
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
	where MSRP > 30000 and Make in ('Acura','Audi'); * <- where is used to filter the data a column needs to display;
	* Logical operator like AND and OR can be used. IN operator is used to assist the filtering in SQL style;
RUN;

* Column definition;
PROC REPORT DATA=CARS_SAMPLE NOWD SPLIT='*'; *<- Split is used to break the column label logically for display;
	define Make/format=$CHAR8. width=3 spacing=10; * Width and spacing has its effect shown only in o/p window and not HTML window;
	define Type/'Car*Type'; * Column label can be defined within ''. To control the word break we can use SPLIT;
	define Cylinders/order descending center width=6 spacing=5;
RUN;

