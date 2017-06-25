/* DO Loop for Iteration
Do Loop for Conditional Iteration using:
	DO-Until
	DO-While
Do loop to generate data
Do Loop to read data

Objective:
==========
1. Construct Do loop to perform repetitive calculation
2. Control the execution of a Do Loop
3. Generate multiple observations in one iteration of the DATA step
4. Construct nested DO loop */

Data A;
	input NUM Name $CHAR6. Wage HrsWorked;
	datalines;
1 Prady 200  4
2 Sruthi 300 5
3 Gokul 400  6
4 Sekar 500  7
5 Sathya 600 8
;
RUN;

PROC PRINT DATA=A;
RUN;

DATA B;
	set A;

	do i = 1 to j by 1;
	Sal_Per_Day=Wage*i;
	end;
RUN;

PROC PRINT DATA=B;
RUN;


