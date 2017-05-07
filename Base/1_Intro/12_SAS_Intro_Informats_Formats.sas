DATA SAMPLE_LOG;
	infile "C:\datasets\samplelog.txt" firstobs=5;

	* Some important formats for positioning the cursor
	* m-n it means read data from column m to n, e.g. Name $ 1-10;
	* n it means read one character from column n;
	* @n it means position the cursor in the nth column for subsequent reading;
	* +n it means move pointer and character forward for subsequent reading;
	* / used to move to next line;
	* #n used to move to nth line;
	* $'CHAR' used to move the cursor to the column which matches 'CHAR';


	* Some important informats for data reading from file
	Character - Used to read char - $3. or $CHAR3.
	Numeric - Used to read integers - 3.2 or COMMA3. or PERCENT2.
	Date - Used to read date field - DATE8. or MMDDYY8.
	Time - Used to read time field - TIME8. or DATETIME8.
	integers at the end of each informats are width;

	* ip address is not a integer, remember it and hence it is in need of $;
	* colon prefix : modifes an informat to stop when a blank is encountered;
	* In below example we used it in file name, so we defined to select untill 55 char but break when any space is found;
	input date YYMMDD10. time TIME8. @44 ip_addr :$16. @'GET' file_name :$55.;

DATA INTYPE_STATES;
	infile "C:\datasets\states.txt" firstobs=3;

	* If by any case the oupput is printed wrongly validate the width and as well the informat used;
	input state $CHAR16. popjul12 COMMA10. popapr10 COMMA12. popapr00 COMMA12. house_seats 4. electors 4.
	pop_per_seat10 COMMA9. pop_per_seat00 COMMA9. pop_per_elector00 COMMA9. percent_US_total_10 PERCENT6.;

DATA US_POPULATION;
	infile "C:\datasets\us-pop.txt" firstobs=4;
	* Try to work more on width space and handle it carefully;
	input Date ANYDTDTE13. @15 National_Population COMMA11. @26 Population_Change COMMA11. @39 Average_Annual_Percent_Change PERCENT4.;
	* These are format style, consider it as opposite to informat;
	format Date MMDDYY.;

PROC SORT;
	by state;
PROC PRINT data=SAMPLE_LOG;
PROC PRINT data=INTYPE_STATES;
PROC PRINT data=US_POPULATION;
*	format date MMDDYY. time TIME8.;
RUN;
QUIT;
