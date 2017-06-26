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

* Do Loop is constructed using DO <Increment Variable> = <Start Value> TO <Stop Value> BY <Increment/Decrement Value>; 
* By Default increment Value is 1;
* By Default Increment Variabel is displayed in results, to stop it getting displayed we need to use DROP statement;
* We can explicitly decrement value by mentioning in -ve value like -1;
DATA B;
	set A;
	do i = 1 to HrsWorked by 1;
	Sal_Per_Day=Wage*i;
	end;
RUN;

DATA C (DROP=i);
	set A;
	do i = 1 to HrsWorked by 1;
	Sal_Per_Day=Wage*i;
	end;
RUN;
PROC PRINT DATA=B;
PROC PRINT DATA=C;
RUN;

*Explicit OUTPUT;
* Output in SAS is used to force SAS write data in PDV to target dataset and print it instantly;
DATA D (DROP=counter);
	value=2000;
	do counter=1 to 20;
		Interest=value*0.075;
		value+interest;
		year+1;
	end;
RUN;
PROC PRINT DATA=D NOOBS;
RUN;

*Explicitly Printing the OUTPUT;
DATA E (DROP=counter);
	value=2000;
	do counter=1 to 20;
		Interest=value*0.075;
		value+interest;
		year+1;
		output; * OUTPUT will force SAS to print the PDV to write to target dataset and get it printed, be careful in placing it at a right place;
	end;
RUN;
PROC PRINT DATA=E NOOBS;
RUN;

* Specifying series of terms;
* Here we can just use the DO loop to get it iterated to generate data;
* We will not have start, stop, increment or decrement values;
DATA F;
	DO i=1,5,3,43,43,453,67,8,9;
	j=i+1;
	OUTPUT;
	END;
RUN;
PROC PRINT DATA=F;
RUN;
* We can also use string to iterate the loop;
DATA F1;
	DO Day='Mon','Tue','Wed','Thu','Fri','Sat','Sun';
	OUTPUT;
	END;
RUN;
PROC PRINT DATA=F1;
RUN;

* Nesting DO loop;
DATA G;
	do year=1 to 20;
		capital=2000;
			do month=1 to 12; * While using nested do loop be careful in using the increment variable, it should be different, else value will get overwritten in PDV and will cause undesired output;
				Interest=capital*(0.075/12);
				capital+interest;
			end;
	end;
RUN;
PROC PRINT DATA=G;
RUN;

* Conditional Do Loop;
* Do Until loop is used to do something untill a condition is met;
* Do While loop is used to do something while a condition is met;
* Important difference is that DO Until will execute atleast once unlike DO-While statement;
DATA H;
	do until(capital >= 50000);
		capital+2000;
		output;
		capital+capital*0.10;
		year+1;
	end;
RUN;
PROC PRINT DATA=H;
RUN;

DATA I;
	do while(capital <= 50000);
		capital+2000;
		output;
		capital+capital*0.10;
		year+1;
	end;
RUN;
PROC PRINT DATA=I;
RUN;

* Creating Sample;
* This is used to create a sample out of a dataset, whcih can be generally used during model building;
* We will use Do loop + POINT + OUTPUT + STOP to derive this;
* However, these are not random samples;
* In below example we are trying to create a sample by picking observations with obs number 10, 20, 30, 40 and 50;
DATA SUBSET;
	do sample=10 to 50 by 10;
		set Clinic.Cap2000 point=sample;
		output;
	end;
	stop;
RUN;
PROC PRINT DATA=SUBSET;
RUN;
