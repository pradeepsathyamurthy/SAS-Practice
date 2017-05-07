/* SAS format is a string of characters which is used for writing output in a correct format */

DATA SAS_FORMATS;
	infile "C:\datasets\samplelog.txt" firstobs=5;
	* Practice more on how to use : and $ at necessary places;
	* : is used to ternimate the cursor selection when a space come across;
	* $ is used when a column is considered as a character, eg ip looks like numeric but it is a char variable;
	input date YYMMDD10. time TIME10. @44 ip_address :$16. @'GET' file_name :$55.;

PROC PRINT;
	
	* like infomat used for selecting data to form a dataset;
	* format is used for writing output in correct format;
	* in below code DATE10. and TIME10. is a format used to write an output;
	* remember that whenever an informat is used for a variable in input command, if they need to be writte in output;
	* we need to reformat it using format command and then print the same;
	format date DATE10. time TIME10. ip_address file_name;

RUN;
QUIT;
