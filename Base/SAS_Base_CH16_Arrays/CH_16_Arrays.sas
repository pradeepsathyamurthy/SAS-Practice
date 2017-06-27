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

* Referencing elements of Array;
DATA C (DROP=i);
	ARRAY Scores[5] Score1 Score2 Score3 Score4 Score5;
	Scores[1] = 89;
	Scores[2] = 90;
	Scores[3] = 92;
	Scores[4] = 97;
	Scores[5] = 100;
	ARRAY Quizs[5] Quiz6 - Quiz10;
	do i=1 to 5;
		Quizs[i] = i*2;
	end;
RUN;
* Remember these will just initiate arrays and will not carry any values;
PROC PRINT DATA=C;
RUN;

* How to use arrays to manipulate the observations;
DATA D;
	input Name $CHAR5. weight1-weight4;
	datalines;
Alici 69.6 68.9 68.8 67.4
Betsy  52.6 52.6 51.7 50.4
;
RUN;

DATA E (DROP=i);
	SET D;
	array weights[4] weight1-weight4;
	do i = 1 to 4;
		weights[i] = weights[i] * 2.24;
	end;
RUN;

PROC PRINT DATA=D;
PROC PRINT DATA=E;
RUN;

* DIM - DIM function is used to find the dimention of an array and use it as a STOP Value in DO loop that gets associated;
DATA F;
	input Name $CHAR5. weight1-weight4;
	datalines;
Alici 69.6 68.9 68.8 67.4
Betsy  52.6 52.6 51.7 50.4
;
RUN;
DATA G (DROP=i);
	SET F;
	array weights[4] weight1-weight4;
	do i = 1 to dim(weights);
		weights[i] = weights[i] * 2.24;
	end;
RUN;
PROC PRINT DATA=F;
PROC PRINT DATA=G;
RUN;

* Creating array variables, to create this we just need to declare an array and not mention any elements for it;
DATA H;
	array weights[4]; * This will create automatic variables like weights1, weights2, weights3 and weights4;
RUN;

* Creating arrays of Character variable;
* Use $ to declare a charcter variable;
* Default Character length is 8;
* If you need to increase the character element size, it needs to be mentioned after $;
DATA I;
	array weights[4] $;
	weights[1]="PRADEEPSATHYAMURTHY";
	array sizes[2] $ 32;
	sizes[1]="PRADEEPSATHYAMURTHY";
RUN;
PROC PRINT DATA=I;
RUN;

* Using array with iterative DO loop;
* In SAS we can deal each observation record by record only;
* So any comparison between each collumn of a particular row is possible so far from what i have read;
* To perform collumn wise comparison you need to use Multi Dimentional array;
* Yet to read how to do the collumn wise comparison;
DATA J (drop = i);
	set Hrd.Ctargets;
	array months[12] Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec;
	array MonDiff[11];
	do i = 1 to dim(MonDiff);
		MonDiff[i] = months[i+1] - months[i];
	end;
RUN;

PROC PRINT DATA=J;
RUN;

* Assigning Initial values to array;
DATA K (drop = i);
	array Nums[3] (1,2,3);
	array Digts[4] (1 2 3 4);
	array Names[3] $ ('Prady','Srut','Prem');
	array Temp[2] _TEMPORARY_ (6,7); * These are temp variables used only for internal SAS usage;
	array Temp_Usg[2];
	do i = 1 to 2;
		Temp_Usg[i] = Temp[i]; * See how _TEMPORARY_ works, it is used internally by SAS;
	end;
RUN;

PROC PRINT DATA=K;
RUN;

* Multi-Dimentional Array;
* Defining Multi-Dimentional Array;
* To define this we need to define dimentions of elements using a comma seperator;
* Generally a multi-dimentional array elements can be accessed using the nested DO loop;
* Here as part of compilation state the PDV is created with all variables;
* Later, for each inner DO loop PDV gets updated for that particular column intermediately;
* And for each outer DO loop PDV gets updated for the particular column permanently;
* Once all the column in the PDV is updated with its respective values, PDV write the result to target dataste;
Data L (DROP = i j count);
	array Temperatures[3,4] Temperature1-Temperature12;
	Count = 1;
	do i = 1 to 3;
		do j = 1 to 4;
			Temperatures[i,j] = Count;
			Count+1;
		end;
	end;
RUN;
PROC PRINT DATA=L;
RUN;

* Arrays can also be used to transpose a dataset;
* This how we change the rows to collumn and vice-versa;
* However, it not a complete transpose, we need to drop column accordingly;
DATA ROTATE (DROP=qtr1-qtr4);
	set finance.funddrive;
	array contrib[4] Qtr1-Qtr4;
	do Qtr=1 to 4;
		Amount=contrib[qtr];
		output;
	end;
RUN;
PROC PRINT DATA = ROTATE noobs;
RUN;
