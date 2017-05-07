/* Various input style in SAS*/

DATA INPUT_STYLES;
	infile "c:/datasets/quiz1.txt" firstobs=3;

	* m-n this is a column style input ;
	input name $ 1-10;

	* n this is also a column style input;
	input q1 11;

	* @n Move pointer to column n for subsequent reading;

	* +n Move the pointer n character forward for subsequent reading;

	* / Skip or move to next line of input;

	* #n skip or move to line n of input;

	* @'chars' Move to past 'chars' character string;

* Pointer Example;
* Use SAS column and line pointers to control data access;
DATA TEST;
   input #3 a $ 3-5 @10 b $2. +5 c $1.
         /  d $ 17-21
         #5 @8 e 5.;
   datalines;
         11111111112222222
12345678901234567890123456
abcdefghijklmnopqrstuvwxyz
zyxwvutsrqponmlkjihgfedcba
12345678910111213141516171
;

PROC PRINT DATA=TEST;

* Converting character to numeric;
DATA TYPE_CONV;
	input s $ x;
	datalines;
Prady 6
;
	val = s + 0;
	val = s * 1;
	val = input(s, 6.2); *<-- 6.2 is an informat;
* Converting numeric to character;
	str = x || "";
	str = put(x, 6.2); *<-- 6.2 is a format;
	output val str;

PROC PRINT DATA=TYPE_CONV;

RUN;
QUIT;
