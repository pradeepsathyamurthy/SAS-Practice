/* 2_SAS_Intro_ColumnStyle_Input */

* This is the input style where we mention the column name and the column number till which it need to be considered the same;
DATA column_style_data;
	infile "C:\datasets\quiz1.txt" firstobs=3;
	* Here we have each collumn name and explicitly mentioned from where it starts till where it ends;
	* If just one collumn length we mention that particular column;
	* We have collumn name starting from collumn number 1 to 10, here we are including embedded space of each names;
	* We have q1 in collumn 11;
	input name $ 1-10 q1 11 q2 12 q3 13 q4 14 q5 15 mid 17-19 final 21-23;

PROC PRINT data=column_style_data;
RUN;
QUIT;
