/* Reading data spread across multiple columns and multiple rows */

DATA data_multi_col;
	infile "C:\datasets\quiz2.txt" firstobs=3;

	* When you read input as below it will only read the data for names in collumn1;
	* That is from Paula to Cynthia, it will ignore all data which are spread horizontally;
	* input name $ 1-10 (q1-q5) (1.) mid final @@;
	
	* First of all, here we cannot use the column style input, so name cannot be defined as name $ 1-10 we need CHAR10.;
	* Secondly, we need to use @@ at end of input line;
	* @@ is used to read all the data in a line/row;
	* @ means hold the input line until the end of the data step;
	input name $CHAR10. (q1-q5) (1.) mid final @@;
	if mid=. then mid=0;
	if final=. then final=0;
	quiz_score=mean(q1,q2,q3,q4,q5);
	total_score=quiz_score*8 + mid*0.3 + final*0.3;
	* For both assigning and equal to operator it is just one = and not ==;
	if total_score>=90 then grade='A';
	else if total_score>=80 then grade='B';
	else if total_score>=70 then grade='C';
	else if total_score>=60 then grade='D';
	else grade='F';
	keep name total_score grade;

PROC PRINT;
RUN;
QUIT;

DATA TEST_1;
	* Will go to first row print first value as x and second value as y;
	* Then it will come to next row as @ is used and moves down untill all rows are read;
	* certainly we will miss reading some dat spread across other collumn if not define with proper input and output;
	input x y @;
	output;
	datalines;
11 12 13 19 32 32 34 43 12 09
45 24 33 34 75 74 45 86 32 54
;

PROC PRINT;
RUN;
QUIT;


DATA TEST_2;
	* certainly we will miss reading some dat spread across other collumn if not define with proper input and output;
	input x y @;
	output;
	input x y @;
	output;
	input x y @;
	output;
	input x y @;
	output;
	input x y @;
	output;
	datalines;
11 12 13 19 32 32 34 43 12 09
45 24 33 34 75 74 45 86 32 54
;

PROC PRINT;

RUN;
QUIT;


