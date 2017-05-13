/* Define and invoke a macro */
/* Creating Modular Code with Macro */
/* It is a simple user defined print function */
/* makes use of %MACRO and %MEND */
/*
The following program creates a macro named %SAMPLE to sort the data by Quantity and print
the five observations with the largest sales. Then the program reads the data in a standard DATA
step, and invokes the macro.
*/
 
%MACRO sample; *<- This is how user defined function is created in SAS;
PROC SORT DATA=FLOWER out=FLOWER_SORTED;
	by decending Quantity;
RUN;
PROC PRINT DATA=FLOWER_SORTED (obs=5);
RUN;
%MEND sample; *<- This is the end of user defined function in SAS;

DATA FLOWER;
	infile 'C:\datasets\tropical-sales.txt';
	input CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
	format SaleDate DATE9.;
RUN;

%sample; * <- This is how the function call happens in SAS;
RUN;

