/* Arrays - This is a like a pointer which points to group of variables under a single name 
	These array consist of group variables of same type, they are all either Numeric or Character types 
	Arrays exists only till the duration of DATA step */

/* Objectives behind this chapter are:
	1. Group Variables into a one dimentional array element
	2. Perform an action on an array elelement
	3. Create new variables with an array element
	4. Assign Initial values to array elements
	5. Create temporary array elements with an array satement */

/*  				ARRAY Name
			|-----|----|----|-----|-----|
Variables   Var1  Var2 Var3 Var4  Var5  Var6
*/

* General form of an ARRAY and Specifying Array Elements;
* ARRAYS have a Name, dimension and array elements (generally group of variables);
* Default DImention is 1 for an array;
* Array elements must be of same type;
* Array lives only within data step, outside data step it will expire;
DATA A;
	ARRAY Scores[5] Score1 Score2 Score3 Score4 Score5;
	ARRAY Quizs[5] Quiz6 - Quiz10;
	ARRAY Sales{3} Sale1 - Sale3;
	ARRAY Days(7) Day1 - Day7;
RUN;

* Remember these will just initiate arrays and will not carry any values;
PROC PRINT DATA=A;
RUN;

* Variable lists as Array Elements;
* {*} is used to define a one dimentional array;
DATA B;
	ARRAY Nums(*) _NUMERIC_; * Specify a Numeric array with zero element;
	ARRAY Chars{*} _CHARACTER_; * Specify a Character array with zero element;
	ARRAY Alls[*] _ALL_; * Specify a genric array with zero element, it specify all variables of same type (all char or all numeric);
RUN;

* Remember these will just initiate arrays and will not carry any values;
PROC PRINT DATA=B;
RUN;

