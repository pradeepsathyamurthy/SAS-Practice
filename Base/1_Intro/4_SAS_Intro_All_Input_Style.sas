/* Looking at other input styles */
DATA quiz1;
	infile "C:\datasets\quiz1.txt" firstobs=3;

	* input name $ quiz_1_5 mid final;
	* What this as done so far is it has read the file, read the place holder name from input and created a dataset;
	* However, quiz 1 to 5 are displayed together as it is given in actual data set;
	* In order to handle this, we need to follow other styles of input;

	/* We will make use of column style and see what happens */
	* Column Style will take care of the trailing space/ Embedded space;
	* It can also take care of length statement itself;
	*input name $ 1-10 q1 11 q2 12 q3 13 q4 14 q5 15 mid final;
	* writing in q1 to q2 in column style is more difficult and hence we can make use formatted style;
	
	* Below has input in all style list, column and formatted style;
	* name, quiz, mid and final is in list style;
	* quiz used both column style (q1-q5) and also formatted style like (1.);
	input name $ 1-10 (q1-q5) (1.) mid final;
	* 1. below is called an informat, it is a very important concept= format for input;
	if final=. then final=0;
	* No need to declare a variable before its usage, just like python;
	quiz_ave=mean(q1,q2,q3,q4,q5);
	course_score=quiz_ave*8 + mid*0.3 + final*0.3;
	if course_score >= 90.0 then grade='A';
	else if course_score >= 80.0 then grade='B';
	else if course_score >= 70.0 then grade='C';
	else if course_score >= 60.0 then grade='D';
	else grade='F';

PROC PRINT;
	var name course_score grade;

DATA MY_SET;
	* $w. is an informat used to read the data by trimming the space;
	* :$w. is an informat used to read the data and stop when it encounters a space;
	* $CHARw. is an informat used to read the data without trimming the spaces;
	* So if you want to reas a text including space use $CHARw. ;
	* If you want to read a text without any space use $w. ;
	* And if you want to read a text which should stop reading when it encounters space use :$w. ;
	* This is applicable for all other informats too;
	input data $10. data1 :$10. data2 $CHAR10.;
	datalines;
	abcde fgh ijkl mnopqrstuvwxyz
;

PROC PRINT;

data numbers;
	* This is a informat used for numbers;
	* w. is used to read the numbers, e.g. 3. used to read 3 numbers;
	* w.n is used to read with decimal points, e.g. 8.3 used to read 8 numbers with 3 decimal values;
    input x 3. +2 y 8.3 z 9.2;
    datalines;
12345678.901234567890123456789
;

proc print;


RUN;
QUIT;
