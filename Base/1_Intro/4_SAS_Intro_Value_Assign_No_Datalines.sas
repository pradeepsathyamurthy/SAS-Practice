/* SAS Special Constant - These are used to assign values to variables without having an explicit datalines or infile command

Special SAS Constants
Example						Description
-------------------------------------------
'25dec2012'd				Date
'25dec2012:3:45:12pm'dt		Date Time
'3:45:12pm't				Time
'09'x  (tab)
'0c'x (form feed)			Hex Character
3.							Numeric
"STRING"||""				String/Char

*/

DATA SAS_CONSTANT_PRACTICE;
	sample_date='25dec2012'd;
	sample_time='3:45:12pm't;
	sample_date_time='25dec2012:3:45:12pm'dt;
	sample_tab_limited='09'x;
	sample_numeric=3.;
	sample_string="PRADY"||"";

PROC PRINT DATA=SAS_CONSTANT_PRACTICE;
	title "Without Formatting";

PROC PRINT DATA=SAS_CONSTANT_PRACTICE;
	format sample_date DATE9.;
	format sample_time TIME20.;
	format sample_date_time DATETIME25.;
	format sample_tab_limited $HEX2.;
	format sample_numeric 5.;
	format sample_string $10.;
	title "With Formatting";

* Verify that Jan 1, 1960 is the SAS zero date using a SAS special date constant;
DATA DATE_VERIFY;
	test_date='1Jan1960'd;
PROC PRINT DATA=DATE_VERIFY;

*The world marathon record was broken yesterday (Apr 9) in Berlin by Dennis Kimetto;
*His time was 2:02.57. Use a SAS special time constant to represent this time;
DATA TIME_VERIFY;
	test_time='2:02:57't;
PROC PRINT DATA=TIME_VERIFY;

*Use the SAS special constant for the tab character to read this tab-delimited file: kids-tab-dlm.txt;

DATA KIDS_TAB_LIMITED;
	infile "C:\datasets\kids-tab-dlm.txt" dlm='09'x dsd;
	input Name $ Gender $ Age;

PROC PRINT DATA=KIDS_TAB_LIMITED;

RUN;
QUIT;

