/* Computing new variable */
* formatting of a variable can be done both at data level or at procedure level;
* when done at data level, change is applied to all procedure;
DATA BULL_ROSTER;
	infile "c:/datasets/bulls-roster-1213.txt" firstobs=5 truncover;
	input number 2. @4 name $21. @23 pos $3. @27 age 2. @30 ht $4. @35 wt 3. @39 college $15. @55 salary DOLLAR14.;
	format salary DOLLAR14.;

PROC PRINT;
	title "Reading and printing the data set";
	var number name pos age ht wt college salary;

RUN;
QUIT;

PROC FORMAT;
	value $POS
      'C'  = 'Center'
      'PF' = 'Power Forward'
      'PG' = 'Point Guard'
      'SF' = 'Small Forward'
      'SG' = 'Shooting Guard';

PROC PRINT;
	title "Dataset with format procedure";
	format pos $POS.;
	var number name pos age ht wt college salary;

RUN;
QUIT;
