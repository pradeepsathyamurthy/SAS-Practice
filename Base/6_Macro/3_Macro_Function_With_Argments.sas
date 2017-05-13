/* Define Macro and Invoke it using Parameters */
/* This is like making function call by passing arguments */
/*
Suppose the grower often needs a report showing sales to an individual customer.
The following program defines a macro that lets the grower select sales for a single customer and
then sort the results. As before, the data contain the customer ID, date of sale, variety of flower,
and quantity.
*/

* This program demands macro with 1 arigument to be passed=> Argument for the function;

%MACRO CUST_REPORT(cust_id=); *<- Defining Marcro with 1 Argument;
DATA FLOWER;
	infile 'C:\datasets\tropical-sales.txt';
	input CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
	format SaleDate DATE9.;
	if CustomerID="&cust_id"; *<- Using the Macro;
RUN;

PROC SORT DATA=FLOWER OUT=FLOWER_SORTED;
	by Variety;
RUN;

PROC PRINT DATA=FLOWER_SORTED;
RUN;
%MEND CUST_REPORT;

%CUST_REPORT(cust_id=240W); * <- Note that we need not use "" here while sendingthe argument value;
%CUST_REPORT(cust_id=356W);
RUN;


* Macro with parameters;
%MACRO select(customer=,sortvar=); *<- Defining Macro with arguments;
PROC SORT DATA = flowersales OUT = salesout;
	BY &sortvar; *<- Using Macro;
	WHERE CustomerID = "&customer"; *<- Using Macro;
RUN;
PROC PRINT DATA = salesout;
	FORMAT SaleDate WORDDATE18.;
	TITLE1 "Orders for Customer Number &customer"; *<- Using Macro;
	TITLE2 "Sorted by &sortvar"; *<- Using Macro;
RUN;
%MEND select;
* Read all the flower sales data;
DATA flowersales;
	infile 'C:\datasets\tropical-sales.txt';
	input CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
RUN;
*Invoke the macro;
%select(customer = 356W, sortvar = Quantity)
%select(customer = 240W, sortvar = Variety)
RUN;
