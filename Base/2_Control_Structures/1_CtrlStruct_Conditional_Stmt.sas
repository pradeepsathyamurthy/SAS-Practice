/* Conditional Operator*/

* Since SAS works only with two data types, integer and char, results of boolean is said to be either 0 or 1;
* CompOp Example Show that the comparison operators return the logical values 0 or 1;
* There is no true or false here because SAS works only with numeric and character data type;

options ls=64 nodate;

DATA COMP_OP;
	* This is an equal to operator;
   expr = (5 eq 5);
   output;

   * This is an geater than operator;
   expr = (7 gt 11);
   output;

   * These are not equal to operators;
   expr = (2 ne 2);
   output;
   expr = (10 ~= 10);
   output;
   expr = (11 ^= 12);
   output;

PROC PRINT;

RUN;
QUIT;
