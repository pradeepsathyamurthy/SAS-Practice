/* Reading SAS DATASETS */
* Here we will study how to read a data from an existing SAS dataset itself;

DATA Work.SAS_DATASET1;
	SET Clinic.Acities; * SET command is used to read a sas dataset;
RUN;
PROC PRINT DATA=Work.SAS_DATASET1;
RUN;

PROC SORT data=Clinic.Acities OUT= WORK.ACITIES_SORTED; * remember to use data= while using proc sort;
	by country;
RUN;

DATA Work.SAS_DATASET2;
	SET Clinic.Acities (DROP=Name); * Drop is used to delete a whole column;
	if country = "USA"; *If is used for Subsetting a data;
	if city = "Stockholm" then delete; *if - then - delete will Drop Unwanted Data;
	if (country = "USA") then Currency = "USD"; else Currency = "XXX"; *Create or Modify the variables;
	if (country = "USA") then GDP = 9; else GDP = 2; *Conditional Execution of Statement;
	retain total_GDP 0; total_GDP+GDP; *Initialize the SUM variable;
	*length city $ 5; *this will not have any effect as length of city is already set;
	length two_years_gdp 5;
	two_years_gdp = 2 * GDP; * this will create column two_years_gdp with length 5;
	label two_years_gdp='GDP two times'; *Label a Variable, to view this use label in the PORC PRINT;
	*date = '12Jan2017';
	*format date $ MMDDYY10.; *Format a variable;

RUN;
PROC PRINT DATA=Work.SAS_DATASET2;
RUN;

DATA Work.SAS_DATASET3;
	set WORK.ACITIES_SORTED;
	by country; * Sorted by a column;
RUN;
PROC PRINT DATA=Work.SAS_DATASET3;
RUN;

DATA Work.SAS_DATASET4;
	obsnum = 5;
	set Clinic.Admit point = obsnum; * POINT is used for direct access of an observation;
	output; *By using POINT SAS will not have EoF to start execution, so explicit output is needed;
	stop; * again due to absence of EoF, we need explicit STOP else dataset will keep iterating;
RUN;
PROC PRINT DATA=Work.SAS_DATASET4;
RUN;

* Multiple SAS DATA set can be created at once;
DATA Work.SAS_DATASET5 Work.SAS_DATASET6;
	set Clinic.Admit;
RUN;
PROC PRINT DATA = Work.SAS_DATASET5;
RUN;

DATA Work.SAS_DATASET7 Work.SAS_DATASET8;
	set Clinic.Admit;
	output Work.SAS_DATASET8; *Observations for SAS_DATASET7 will be 0, only variables would be created. However, SAS_DATASET8 is filled with observations;
RUN;
PROC PRINT DATA = Work.SAS_DATASET7;
RUN;
PROC PRINT DATA = Work.SAS_DATASET8;
RUN;
