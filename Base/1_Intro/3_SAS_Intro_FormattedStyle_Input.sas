/* 3_SAS_Intro_FormattedStyle_Input */
* More than one input style can be used in a input statement;
DATA formatted_style_input;
	infile "C:\datasets\quiz1.txt" firstobs=3;

	* We have used formatted style below, we have defined the quiz in formatted style;
	* These need to be represented mostly in ();
	* (q1-q5) means we have 5 variable called q1 q2 q3 q4 q5;
	* (1.) indicates the informat, which means the input format of a variable;
	* (1.) means we have a integer of length 1;
	input name $ 1-10 (q1-q5) (1.) mid final;

PROC PRINT data=formatted_style_input;

RUN;
QUIT;

