/* Creating and Managing Variables */
* LIBNAME libref 'C:\Users\prade\Documents\My SAS Files\9.4';
*PROC CONTENTS DATA=Clinic.Stress2;
*RUN;

* Reading a SAS Dataset;
DATA WORK.STRESS_PRACTICE;
set Clinic.Stress2;

* accumilator variable (sumsec), this is just like a counter variable;
retain sumsec 3000; * This is how the accumilator variable is initialized;
sumsec+TimeSec; * Defining the accumilator variable sumsec;

* Creating values conditionally;
totaltime=(timemin*60)+timesec; * Creating values without any condition ;
if totaltime > 800 then TestLength='Long'; * This is called conditional value/column creation;
/* Some of the conditional operator are:
= or eq
~= or ^= or ne
> or gt
< or lt
>= or ge
<= or le
in
&
|
*/
* Becarefu with the variable name used, else PDV will just create a column and no values into it;
if Tolerance in ('D','I') then Rate=totaltime*2; * Using the in operator;
if Tolerance='N' | Tolerance='S' then Rate=totaltime*3; * Using the or operator;

/* Using the ELSE statement
	without else-if statement SAS will have to process all if statement
	thus using IF statement is quite a efficient method of coding 
	Also please note that whenever you use else if, go with checking decrease in probablity */
if totaltime > 800 then TestLength='Long';
else if 750 <= totaltime <= 800 then TestLength='Normal'; * look at how the comparison operator is used here;
else if totaltime < 750 then TestLength='Short';
else put 'Note: Check this length: ' totaltime=;

* however, if you see the result before this step 'TestLength' would have a truncated value;
* to avoid this we need to explicitly mention the length, else the length of first encountered string would be considered as its length;
length TestLength_Mod $ 10.;
if totaltime > 800 then TestLength_Mod='Long';
else if 750 <= totaltime <= 800 then TestLength_Mod='Normal'; * look at how the comparison operator is used here;
else if totaltime < 750 then TestLength_Mod='Short';
else put 'Note: Check this length: ' totaltime=;

* Deleting the observation;
* this will delete the whole row from the SAS dataset;
if resthr <70 then delete;
if resthr >70 then TempVar='Delete this row';

* Using drop= and drop
* there is a subtle difference between both:
* 1. DROP statement cannot be used in SAS procedure. However, drop= can be used;
* 2. When Drop= is used in datastep it means, use those drop variables in data creation an finally drop it while creating output dataset;
* 3. When Drop is used inside datastep it does the same thing, however functionality differs when used drop= inside SET command;
drop TempVar;

* Assigning permanent labels and formats;
* To assign temporary labels it can be mentioned inside any procedures;
* These labels and formats only affect the output data display and not the actual dataset;
format rate COMMA10.2;
label Rate='Temp Rate Variable';

* Using Select-When in SAS is like using SWITCH case in any other language;
* Select statement is optional, if select is not given when statement would be validated and gets stops after first true occurence;
select (ID);
when ("2458") group = "Flight Attended I";
when ("2501") group = "Flight Attended";
otherwise group = "others";
end;

* Grouping statement;
* Remember we will not use semicolon after when statement while using do-end into it;
select (Testlength_Mod);
when ('Normal')
	do;
		amount=8*totaltime;
		format amount DOLLAR15.;
	end;
otherwise amount=0;
end;

 

RUN;

PROC PRINT DATA=WORK.STRESS_PRACTICE label; * to print the labels used in dataset it needs to be explicitly mentioned;
RUN;
