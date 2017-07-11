*PROC PRINT;
DATA WORK.IRIS_PRACTICE;
	set SASHELP.iris;
RUN;

* Simple report using proc print;
PROC PRINT DATA=WORK.IRIS_PRACTICE (OBS=10); * <- OBS needs to be given inside () and this will disply first 10 rows of data;
run;

* Column total using proc print;
* finding the total for sepal length;
PROC PRINT DATA=WORK.IRIS_PRACTICE;
	sum sepallength;
run;

*Sorting the data in SAS dataset; * When sorted out must be used to generate new dataset else PROC SORT will disturb the existing dataset;
PROC SORT DATA=WORK.IRIS_PRACTICE OUT=WORK.IRIS_PRACTICE_SORTED;
	by descending sepallength petallength;
RUN;

PROC PRINT DATA=WORK.IRIS_PRACTICE_SORTED LABEL; *you got to use explicit LABEL to print the label;
	var species petallength sepallength; *mentions the order in which the data needs to be printed;
	label Species='IRIS Flower Type';
RUN;

PROC PRINT DATA=WORK.IRIS_PRACTICE_SORTED; *Var, label mentioned in previous statement are locally scoped and not global;
RUN;

* Selected observations and variables - Filtering;
PROC PRINT DATA=WORK.IRIS_PRACTICE noobs;
	where sepallength >30; *Filtering option in SAS;
run;

* Identifying observation to act as primary key;
PROC PRINT DATA=WORK.IRIS_PRACTICE;
	ID sepallength; *this makes sepal length as a primary key for the dataset,becareful while definig these columns;
run;

PROC PRINT DATA=WORK.IRIS_PRACTICE;
	ID sepallength; 
	var Species sepallength petallength; *Sepal length appear twice one as a primary key and one as a ordinary column;
run;

* Using the Contains operator;
PROC PRINT DATA=WORK.IRIS_PRACTICE;
	WHERE species contains 'Ver' or species contains 'Vir'; *CONTAINS check substring;
run;

PROC PRINT DATA=WORK.IRIS_PRACTICE;
	WHERE species ? 'Ver' or species ? 'Vir'; *CONTAINS check substring, ? can be used as a substitute;
run;

PROC PRINT DATA=WORK.IRIS_PRACTICE;
	WHERE sepallength>30 and petallength>50; *usage of logical operator AND/OR;
run;

PROC PRINT DATA=WORK.IRIS_PRACTICE;
	WHERE species in ('Versicolor','Virginica'); *This is a SQL style IN operator, remember string within quotes are case sensitive;
run;

* Using SUM to total the specific numerical data;
PROC PRINT DATA=WORK.IRIS_PRACTICE;
	WHERE sepallength>30 and petallength>50;
	SUM sepallength petallength; * SUM will provide the total of values mentioned;
run;

* Sandwiching the SORT and PRINT statement;

PROC SORT DATA=WORK.IRIS_PRACTICE OUT=WORK.IRIS_PRACTICE_SORTED;
	by species;
RUN;

PROC PRINT DATA=WORK.IRIS_PRACTICE_SORTED;
	var sepallength petalwidth;
	where sepalwidth>30 and petallength >30;
	sum sepallength petalwidth;
	by species; * This will sandwidth the report based on the species;
RUN;

* Usage of ID and BY statement together;
PROC PRINT DATA=WORK.IRIS_PRACTICE_SORTED;
	var sepallength petalwidth;
	where sepalwidth>30 and petallength >30;
	sum sepallength petalwidth;
	by species;
	id species;
RUN;

* Printing page total in seperate page;
PROC PRINT DATA=WORK.IRIS_PRACTICE_SORTED;
	var sepallength petalwidth;
	where sepalwidth>30 and petallength >30;
	sum sepallength petalwidth;
	by species;
	id species;
	pageby species;
RUN;

