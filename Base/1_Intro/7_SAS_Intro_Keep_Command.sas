/* 3_SAS_Intro_FormattedStyle_Input */
* More than one input style can be used in a input statement;
DATA formatted_style_input;
	infile "C:\datasets\quiz1.txt" firstobs=3;
	input name $ 1-10 (q1-q5) (1.) mid final;

	* Keep command is to decide what collumn need to be kept in SAS dataset which will be in RAM;
	* Normally it is not necessary to keep all data as part of SAS dataset, we can do that using keep command;
	* Below command will only have name, midterm and final scores as part of SAS dataset even though it reads whole file;
	keep name mid final;

PROC PRINT data=formatted_style_input;

RUN;
QUIT;

