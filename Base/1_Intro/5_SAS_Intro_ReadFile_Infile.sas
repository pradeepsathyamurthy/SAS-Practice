DATA kids;
* Alway when you use a infile make sure your data file has no blank lines at the end of file;
* firstobs is used to define from which line data need to be read;
	INFILE "C:\datasets\kids.txt" firstobs=2;

	* Default variable size is 8;
	* So if we just try to read a file without mentioning its length, SAS will truncate the data to 8 char;
	* length command will help to extend the variable length, remember char need to be defined with $ here as well;
	length Name $ 16;
	INPUT Name $ Gender $ Age;

	* Label is command used to describe a variable created through Input command;
	LABEL Name="Name of Kid"
			Gender="Gender of Kids"
			Age="Age of Kids";

*PROC contents;
*PROC PRINT data=kids;
*PROC COUNT data=kids;

* To find the number of observations we can make use of proc means procedure;
PROC MEANS N;
* finds the minimum and maximum ages of the kids;
PROC MEANS min max;

* finds the minimum and maximum ages as well as the total number of the girls and boys separately;
* before applying any filter for a result, data needs to be sorted based on that column;
* This is because SAS executes data row by row and hence sorting is necessary;
* Proc Sort is used to sort a column;
* by operator is a must key word for a filter;
PROC SORT; 
	by Gender;
PROC MEANS N min max;
	by Gender;

* finds the first girl and boy names in alphabetical order;
* You need to sort the data first;
* Use obs key word with Proc Print and a where operator to apply the filter condition;
PROC SORT;
	by Name;
PROC PRINT data=kids (obs=1);
	where Gender="F";
PROC PRINT data=kids (obs=1);
	where Gender="M";

* Data frame and Data set are two different concept;
* If you need to create a new data frame then you can use out command, however this will occupy more RAM memory;
PROC SORT out=kidssorted;
	by Name;
PROC PRINT data=kidssorted;

RUN;
* The result window which displays the result after it runs is called Output Delivery System (ODS);
QUIT;
