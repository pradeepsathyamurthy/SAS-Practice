/* ODS Practice */

DATA WORK.CARS_SAMPLE1;
	set SASHELP.CARS;
RUN;

ODS LISTING CLOSE; *LISTING is the default format of ODS output display, so to supress it we need to close it explicitly;
ODS HTML BODY='D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH10_ODS\CARS_SAMPLE1_OUTPUT.html';
* Please note Body is an important keyword to mention the absolute path with file name;
* When we say absolute path with file name, we need to mention the name of thr HTML file that we expect to create;
* This will create a HTML output in the path mentioned;
* Remember there is nothing like OPEN keyword, there is only CLOSE keyword for each ODS types;
PROC PRINT DATA=CARS_SAMPLE1 (OBS=10);
RUN;

ODS HTML CLOSE;
ODS LISTING; *It is always a best practice to keep the listing output open before we end any SAS programs;


/* Closing multiple ODS files in one go - using ODS */

ODS LISTING CLOSE; *LISTING is the default format of ODS output display, so to supress it we need to close it explicitly;
ODS HTML BODY='D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH10_ODS\CARS_SAMPLE1_OUTPUT2.html';
ODS PDF BODY='D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH10_ODS\CARS_SAMPLE1_OUTPUT2.PDF';

* Please note Body is an important keyword to mention the absolute path with file name;
* When we say absolute path with file name, we need to mention the name of thr HTML file that we expect to create;
* This will create a HTML output in the path mentioned;
* Remember there is nothing like OPEN keyword, there is only CLOSE keyword for each ODS types;
PROC PRINT DATA=CARS_SAMPLE1 (OBS=10);
RUN;

PROC SORT DATA=CARS_SAMPLE1;
	by Make;
RUN;

PROC PRINT DATA=CARS_SAMPLE1;
RUN;

ODS _ALL_ CLOSE; *_ALL_ is used to close all ODS output with one single command;
ODS LISTING; * We open this because _ALL_ will close all the ODS output and hence we need to explicitly have this open as part of best practice;

/* Creating html output with table a table of contents */
* These are used if any report needs to be showed based on a server request-response model;
* Here we mention 
	1. Body: This carries the data that is needed to be displayed as part of PORC execution
	2. Contents: This carries the data that is has the link reference to each sucessful proc execution
	3. Frame: This will link both Body and Contents files;
ODS LISTING CLOSE; 
ODS HTML 
	BODY='D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH10_ODS\CARS_SAMPLE1_OUTPUT3.html'
	CONTENTS='D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH10_ODS\CARS_SAMPLE1_CONTENT3.html'
	FRAME='D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH10_ODS\CARS_SAMPLE1_FRAME3.html';
PROC PRINT DATA=CARS_SAMPLE1 (OBS=10);
RUN;
ODS HTML CLOSE; *_ALL_ is used to close all ODS output with one single command;
ODS LISTING; * We open this because _ALL_ will close all the ODS output and hence we need to explicitly have this open as part of best practice;

