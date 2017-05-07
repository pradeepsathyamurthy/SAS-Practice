/* do loop statement - do - to/while - end*/
/* this is used when we need to do iteration in SAS code

* Definite Loop;
* Repeat loop with the index i taking on the values from m to n;

do i = m to n;
   action-statements;
end;

* Infinite Loop;
* Repeat the loop while the condition is true;

do while(condition);
   action-statements;
end;

* Repeat the loop until the condition is true (while the condition is false);

do until(condition);
   action-statements;
end;

*/

* Quiz4 Example
  Use a do loop to output one exam score per line;

options ls=64 nodate pageno=1;

DATA QUIZ;
	infile 'c:/datasets/quiz1.txt' firstobs=3;
	input name $ @11 @;

	do test = 1 to 5;
		input score 1. @;
		output;
	end;

	test = 6;
	input score @;
	output;

	test = 7;
	input score @;
	output;

proc print;

run;
quit;
