/* ODS Practice */

DATA WORK.CARS_SAMPLE1;
	set SASHELP.CARS;
RUN;

ODS LISTING CLOSE; *LISTING is the default format of ODS output display, so to supress it we need to close it explicitly;
ODS HTML BODY='D:\Courses\SAS\SAS-Practice\Base\SAS_Base_CH10_ODS\CARS_SAMPLE1_OUTPUT.html';
* Please note Body is an important keyword to mention the absolute path with file name;
* When we say absolute path with file name, we need to mention the name of thr HTML file that we expect to create;
* This will create a HTML output in the path mentioned;
PROC PRINT DATA=CARS_SAMPLE1 (OBS=10);
RUN;

ODS HTML CLOSE;
ODS LISTING OPEN;

