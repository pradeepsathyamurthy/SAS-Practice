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
if Tolerance='N' | Tolerence='S' then Rate=totaltime*3; * Using the or operator;
RUN;

PROC PRINT DATA=WORK.STRESS_PRACTICE;
RUN;
