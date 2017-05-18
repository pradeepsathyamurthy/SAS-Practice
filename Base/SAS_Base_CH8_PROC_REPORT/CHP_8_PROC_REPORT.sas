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
PROC REPORT DATA=CARS_SAMPLE NOWD SPLIT='*' HEADLINE HEADSKIP; 
	* <- Split is used to break the column label logically for display;
	* <- HEADLINE is used to provide a dotted line below the column names, this affects only o/p window and not HTML report;
	* <- HEADSKIP provide a space below the column label and its values, this affects only o/p window and not HTML report;
	define Make/format=$CHAR8. width=3 spacing=10; * Width and spacing has its effect shown only in o/p window and not HTML window;
	define Type/'Car*Type'; * Column label can be defined within ''. To control the word break we can use SPLIT;
	define Model/center; * Default is left justify the char and right justify the numeric, center would centerise the values in column;
	define Cylinders/order DESCENDING; * Data is ordered based on the column Cylinder, this is like grouping and odering, default ordering is ascending;
	define Cylinders/group; * <- If just one column or numeric column is grouped, the result fetched is same as order by;
RUN;

* Column definition - usage of group definition;
PROC REPORT DATA=CARS_SAMPLE NOWD SPLIT='*' HEADLINE HEADSKIP;
	column cylinders MSRP;
	define cylinders/group; * This will group all the Cylinder or categorical data together and produce a summary report on rest of the numerical columns;
RUN;

* Specifying statistics;
PROC REPORT DATA=CARS_SAMPLE NOWD SPLIT='*' HEADLINE HEADSKIP;
	column cylinders MSRP;
	define cylinders/group;
	define MSRP/mean 'Average of MSRP'; * Specifying statistic to compute MEAN;
RUN;

* Column definition - usage of across definition;
PROC REPORT DATA=CARS_SAMPLE NOWD SPLIT='*' HEADLINE HEADSKIP;
	column cylinders type MSRP;
	define cylinders/across; 
	define type/across;
RUN;
