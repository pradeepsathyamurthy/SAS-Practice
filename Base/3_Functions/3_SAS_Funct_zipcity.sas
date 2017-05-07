DATA ZIP_DET;
	input zipcode;
	zip_city=zipcity(zipcode);
	datalines;
60607
;

PROC PRINT;
	title "Output of ZIPCITY function usage in SAS";
	var zip_city;

RUN;
QUIT;
