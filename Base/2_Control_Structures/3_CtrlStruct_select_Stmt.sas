/* select statement - select - when - otherwise - end */
/* This is a consise method of if-else statement 
A select statement can represent an if ... else statement in a more concise manner, its like a switch statement in SAS:

select(expression)
   when(constanta, ... , constantb)
      action1;
   when(constantc, ... , constantd)
      action2;
   ...
      ...
   when(constanty, ... , constantz)
   otherwise
      default action;
end;

*/

* StateRegions2 Example
  Classify states by the four census regions:
  Northeast, Midwest, South, and West.
  Use a select statement;

options ls=64 nodate pageno=1;

DATA STATES2;
   infile 'c:/datasets/states2.txt' truncover;
   input state $14.;

	select(state);

		when ('Maine', 'New Hampshire', 'Vermont', 'Massachusetts',
	            'Rhode Island', 'Connecticut', 'New York', 'Pennsylvania',
	            'New Jersey', 'Northeast') 
	         region = 'Northeast';

		when ('Wisconsin', 'Michigan', 'Illinois', 'Indiana', 'Ohio',
	            'Missouri', 'North Dakota', 'South Dakota', 'Nebraska', 
	            'Kansas', 'Minnesota', 'Iowa') 
	         region = 'Midwest';


		when ('Delaware', 'Maryland', 'Virginia', 'West Virginia',
	             'North Carolina', 'South Carolina', 'Georgia', 'Florida',
	             'Kentucky', 'Kentucky', 'Tennessee', 'Mississippi', 
	             'Alabama', 'Oklahoma', 'Texas', 'Arkansas', 'Louisiana')
			 region = 'South';


		when ('Idaho', 'Montana', 'Wyoming', 'Nevada', 'Utah', 'Colorado',
	            'Arizona', 'New Mexico', 'Alaska', 'Washington', 'Oregon', 
	            'California', 'Hawaii')
	         region = 'West';
	      otherwise;

	end;

proc print;

run;
quit;
