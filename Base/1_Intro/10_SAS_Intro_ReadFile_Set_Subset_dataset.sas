/* Set and Subsetting a data set*/

DATA KIDS_1;
	infile 'c:/datasets/kids.txt' firstobs=2;
	* see how : is used to read names;
	input name :$10. gender $ age;

PROC SORT;
	by name;

DATA OLDER_GIRLS;
	* We use set command with end operator to read through the complete dataset;
	* Also make sure the dataset you read get sorted in a way and you by variable should be that;
	set KIDS_1 end=eof;
	by name;
	if age<11 then delete;

PROC PRINT DATA=KIDS_1;
PROC PRINT DATA=OLDER_GIRLS;

RUN;
QUIT;
