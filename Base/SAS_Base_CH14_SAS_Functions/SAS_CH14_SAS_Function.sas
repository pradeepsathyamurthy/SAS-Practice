/* Mathematical Functions */

DATA Sample1;
	length Firstname $ 12 Lastname $ 12 Age 3 Tel $ 12;
	input FirstName $ LastName $ Age Dob tel $;
	informat DOB ANYDTDTE12.;
	array prady{5} (1,2,3,4,5);
	array srut{2} $8 ('Prady','Srut');
	datalines;
Pradeep Sathyamurthy 31 08MAY1985 312-543-5776
Sruthi Sekaran 23 20DEC1993 966-398-1190
;
RUN;

PROC PRINT DATA=Sample1;
RUN;

DATA Sample2 (DROP=Prady1-Prady5 Srut1-Srut2);
	array prady{5} (1,2,3,4,5);
	array srut{2} $8 ('Prady','Srut');
	sum1 = sum(prady1,prady2,prady3,prady4,prady5); * arguments can be varibales like this eg, constants or even expression;
	sum2 = sum(of prady1-prady5); * of must be used when using series of variables;
	sum3 = sum(of prady{5}); * of is also used when using array, it shold be used with number of elements to show which are getting invoved in this function;
	mean1 = mean(prady1,prady2,prady3,prady4,prady5);
	min1 = min (prady1,prady2,prady3,prady4,prady5);
	max1 = max (prady1,prady2,prady3,prady4,prady5);
	var1 = var (prady1,prady2,prady3,prady4,prady5);
	std1 = std (prady1,prady2,prady3,prady4,prady5);

	* using length - Default length of char function is 200, however using defaul length will consume more space so use LENGTH;
	length data1 5;
	data1 = sum(10000+10000);
	
	* Type Casting;
	* Implicit casting will convert char to num and putnote in log;
	* Char to integer;
	int1 = '200'+0; * Implicit casting;
	int2 = '300'*1; * Implicit casting - by defaul w.d informat is used;
	int3 = input('300',3.)+0;
	int4 = input('300',3.)*1;
	* Integer to Char;
	char1 = 'Prady' || '1'; * Implicit - this will concatenate with spacem, by defaul BEST12. format is used;
	char2 = 'Prady' || put(1,$5.);
	char3 = 'Pradeep' || 'Sathyamurthy';
	char4 = 'Prady' || 1;
RUN;

PROC PRINT DATA=Sample2;
RUN;

DATA SAMPLE3;
	Date0 = '01Jan1961'D;
	Date1 = '03Nov2017'D;
	Date2 = MDY(08,05,1985); * This will create a SAS DATE, that is number of days from 01jan1960;
	DATE3 = TODAY(); *wil give current SAS date, that is number of days from 01jan1960;
	Date4 = DATE(); *will give current system date alone as SAS Date, that is number of days from 01jan1960;
	Date5 = TIME(); * will give current time, that is number of seconds from midnight of 01jan1960;
	Date6 = DAY(Date1); * will give the day part from the SAS Date, return type is numeric;
	Date7 = WEEKDAY(Date1); * Will give number of day in a week rangle of 1-7, sunday being 1;
	Date8 = MONTH(Date1); * gives month frm the sas date;
	Date9 = QTR(Date1); * gives QTR value;
	Date10 = YEAR(Date1); * Gives year value;
	Date11 = INTCK('Day',date0,date1); * it impies interval, first argument can be Day, week, month, Qtr or year.;
	*Date12 = INTNX (); * Has something to do with spl characters;
	Date13 = DATDIF(date0,date1,ACT/ACT);
	Date14 = YRDIF(date0,date1,ACT/ACT);
RUN;

PROC PRINT DATA=SAMPLE3;
RUN;

/* Character functions */
DATA SAMPLE4;
	Name1='Pradeep ';
	Name2='Sathya-murthy';
	City = 'Chennai';
	State = 'Tamil Nadu';
	Country = 'India';
	FULNAME = NAME1||Name2; * This is a kind of concatenation;
	Fullname1 = SCAN(Name2,-2,'-'); * This will scan the string and break them into individual words based on the delimiter specified, SAS has list of default delimiters which also inclue space, -2 does a reverse search from right to left;
	Fullname2 = SUBSTR(Name1,4,4); * This will split the word based on its index value specified, second argument is start index and third argument is stop index;
	Fullname3 = TRIM(Name1)||Name2; * This will trim all blank spaces left and right for a particular word or string;
	Fullname4 = CAT(Name1,Name2); * This will just concatenate, alternative for ||;
	Fullname5 = CATX(',', City, State,Country); * Generally used to create address fields, that is it it concatenates based on a delimiter;
	Fullname6 = INDEX(Name2,'murthy'); * It returns the numeric value, that is the index of the occurence of first word;
	Fullname7 = FIND(Name2,'murthy','i'); * same as INDEX, but this as a option from where the search need to begin and modifers with value 'i' and 't'. 'i' implies ignore case, 't' - trim blank space;
	Fullname8 = UPCASE(Name1); * This can carry only one argument and change it to upper case;
	Fullname9 = LOWCASE(Name2); * This can carry only one argument and change it to lower case;
	Fullname10 = PROPCASE('Pradeep kumar sathyamurthy'); * This will change character to Proper case, that is first char of all word will be capital;
	Fullname11 = TRANWRD(Name2,'murthy','moorthy'); * This is like a search and replace function, returns a string;
RUN;

PROC PRINT DATA=SAMPLE4;
RUN;

/* Integer Functions */
DATA SAMPLE5;
	Num1 = 11.23;
	Num2 = -45.38;
	Number1 = INT(Num1); * Returns integer value, any number after decimal would be discarded;
	Number2 = ROUND(Num2,.2); * Will round off the value based on largest value, we can define round of unit as second param;
RUN;

PROC PRINT DATA=SAMPLE5;
RUN;
