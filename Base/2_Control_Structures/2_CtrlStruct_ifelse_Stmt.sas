/* if-else statement */
/* syntax of if statements

* just one action;
if condition then action;

* sequence of action;
if condition then do;
   action_statements;
end

* else if condition;
if condition1 then action1;
else if condition2 then action2;
else default_action;

* if else fo - becareful wile using this statement;
if condition1 then do;
   action1 statements;
else condition2 then do;
   action2 statements;
else do;
   default_action statements;
end;

*/

* Subsetting if;
DATA SAM;
	input x y z;
	datalines;
1 2 3
4 1 3
5 2 3
6 5 7
7 1 4
8 6 0
9 2 4
;

DATA SAM2;
 set sam;
 if x=5 then z=5;

PROC PRINT data=sam2;

* StateRegions1 Example
  Classify states by the four census regions:
  Northeast, Midwest, South, and West.
  Use if..else statements;
  
DATA STATES;
   infile 'c:/datasets/states2.txt' truncover;
   input state $14.;

	if state='Maine' or state='New Hampshire' or state='Vermont' or
      state='Massachusetts' or state='Rhode Island' or state='Connecticut' or
      state='New York' or state='Pennsylvania' or state='New Jersey' then do;
         region = 'Northeast';
  	end;

	else if state='Wisconsin' or state='Michigan' or state='Illinois' or 
      state='Indiana' or state='Ohio' or state='Missouri' or 
      state='North Dakota' or state='South Dakota' or state='Nebraska' or 
      state='Kansas' or state='Minnesota' or state='Iowa' then do;
        region = 'Midwest';
   	end;

	else if state='Delaware' or state='Maryland' or state='Virginia' or
      state='West Virginia' or state='North Carolina' or 
      state='South Carolina' or state='Georgia' or state='Florida' or
      state='Kentucky' or state='Kentucky' or state='Tennessee' or
      state='Mississippi' or state='Alabama' or state='Oklahoma' or
      state='Texas' or state='Arkansas' or state='Louisiana' then do;
        region = 'South';
   	end;

	else if state='Idaho' or state='Montana' or state='Wyoming' or
      state='Nevada' or state='Utah' or state='Colorado' or 
      state='Arizona' or state='New Mexico' or state='Alaska' or
      state='Washington' or state='Oregon' or state='California' or
      state='Hawaii' then do;
        region = 'West';
   	end;

PROC PRINT;

RUN;
QUIT;
