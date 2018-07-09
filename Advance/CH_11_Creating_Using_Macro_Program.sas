/* Ch-11 - Creating and Using Macro Program */
* Macros and Macro Variables are two different objects in SAS;
* Very Important - Macro Variable use conditional logic to make decisions about the text we substitute into our program;
* Macros are used to:
	1. Automate
	2. Dynamic
	3. Reusable;
* Think Macro as a user defined function in SAS;

* 1. Creating or Defining Macros;
* To Create a macro, we need to first define it;
/* defining format is: %MACRO <Macro_Name>; ..... %MEND <Macro_Name>; */
* Macro_Name: is any valid SAS name, that do not carry any SAS key words;
* Including Macro_Name in %MEND is optional, but for best coding practice it is better to exist;
* When you submit the below code, Macro processor compiles these code and put an entry in default catalog, they do not execute until it is called for execution;
%MACRO print_last_dataset;
	PROC PRINT DATA=&syslast (obs=5); *&syslast is a automatic SAS Macro Variable, used to fetch last used dataset;
	RUN;
%MEND print_last_dataset;

* 2. Compiling a Macro;
* We can compile a Macro by submitting the %MACRO block;
* Once submit > Input Stack > Work Scanner > Tokenize > Macro Triggers > Macro Processor > Compilation > O/P macro result in symbol table;
* Macro Processor does the job of compilation of SAS Macros, they:
	1. Check syntax error
	2. Write error to SAS log is any error found
	3. Stores all compiled SAS macro language program stmt and constant text in a SAS catalog entry;
			* default catalog name is work.sasmacr.<Macro_Name>.Macro;
			* by default macro created will get stored in WORK folder, if needed permanent then it can be changed to one of the permanant SAS folder;
			* understand carefully, only Program stmt and constant values get stored in SAS catelog, any MV are stored only in Symbol table;
* On compilation, SAS look for error in Macro and if no error, it stores the stmt in SAS catelog and stay ready for execution whenever called;
%MACRO eg_1;
	%put "hi google";
%MEND eg_1;

* 3. MCOMPILENOTE= ;
* It is a SAS options, used to display Notes when there is any issue with compiling the SAS Macros;
* When there is no issue, it prints the note saying of success in compilation;
* It comes with 3 options:
	1. None = Defaul, no note is issued
	2. NOAUTOCALL = Note issued for all Macros except auto call macros
	3. ALL = Note issues for all completed Macro compilations;
* When there is any compilation error they will be displayed in SAS log as ERROR;
options mcompilenote=all;
%macro mymacro;
%mend mymacro;

* 4. Calling a Macro;
* Executing a macro is called as calling a Macro, calling is done like:
	1. placing a %<macro_name>
	2. No need of semicolon as it is not a SAS statement, including it will give inappropriate results
	3. Can be called anywhere in the SAS program except in the DATALINES;
* Macro can be called in 3 style:
	1. Name Style - this is the main focus
	2. Command Style
	3. Statement Style;
* Doing below sort to create a last accessed Dataset exist;
PROC SORT DATA=SASUSER.ACITIES;
	by city;
RUN;
* Now calling the macro print_last_dataset;
%print_last_dataset
* In SAS log we can notice not the whole code of PROC PRINT is printed because, SAS executes a compiled code here;

* 5. Macro execution;
* Macros executes before any SAS Data step or PROC steps;
* Macro call is processed by SAS Macro Processor even before a SAS prog steps like DATA or PROC compile and executes;
* When a macro code is executed:
	1. SAS seach for particular compled code in SAS catelog file
	2. Once found, executed those compiled code and stored the result in Global and Local symbol table
	3. Process and executes any DATA or PROC steps
	4. Once done resumes with the macro execution again to check if anymore macro exist to execute and terminate the execution when %MEND is found;
* Macro Processor can communicate directly with global and local symbol tables and input stacks;
* Remember during Macro execution, macro processor cannot directly communicate with SASDATSET to obtain or modify a value of DATA step variable;
* Also when a macro executes the compiled code, the source code doesnt get printed in log;

* 6. Devloping and Debugging Macros - SAS System OPTIONS;
* 6.1. MPRINT | NOMPRINT
* Debugging Macro means monitoring macro execution using the systems OPTIONS;
* MPRINT - used to print the text that is sent to the SAS compiler as a result of SAS execution;
* This is a SAS Systems option, helpful in displaying the info about macro execution;
* Used especially for debugging;
* It has two flavour:
	1. NOMPRINT - default, source code not printed in SAS log
	2. MPRINT - Print the source code that gets executed in SAS log;
* Used when there is a syntax error or when we need to look at the source code;
OPTIONS MPRINT;
%print_last_dataset
* let is switch-off the MPRINT option;
OPTIONS NOMPRINT;
%print_last_dataset

* 6.2. MLOGIC | NOMLOGIC
* Used to print the Macro actions that have been taken during Macro execution;
* Macro Action includes:
	1. Beginning of Macro Execution
	2. Results of arithmatic and logical macro operations
	3. End of Macro Execution;
* It has two flavor:
	1. NOMLOGIC - default, doesnt print note about macro actions
	2. MLOGIC - Print notes about macro actions;
OPTIONS MLOGIC;
%print_last_dataset
OPTIONS NOMLOGIC;
%print_last_dataset

* 7. Comments in SAS Macro Language;
* There are 2 types of commenting a macro statement;
	* 1. %* <some_text> ;
	* 2. /* <some_text */ ;

* 8. Using Macro Parameters;
* We know macro is like a function implementation in SAS;
* Macro Parameters are like function with parameters;
* Macros generally contain Macro variables, and these MV makes the Macros more dynamic;
* %LET will allow to update the Macro variables in the local symbol table;
* However, parameter list used within Macro does the job seemlessly easy;
* Parameter list is an optional part of %MACRO statement;
* These parameter list names of one or more macro variable whose value we specify when we call that Macro;
* Positional Paramters is an important concept;
* With positional parameters Macro Variable will get automatically created;
* Order in which parameter is defined is important in positional parameter;
/* General Format is as below:
%MACRO <macro_name>(param1, param2);
...
...
...
%MEND <macro_name>;
Values passed to parameter list can be:
	1. NULL
	2. Text
	3. Macro Variable references
	4. Macro Calls */
* values passed to paramter list are assigned in one to one correspondence;
* created a sample Macro with param list;
* In below program dsn and vars will become a Macro Variable internally, hence they need to be referenced with & before;
* Position parameters;
%MACRO printdsn(dsn,vars);
	PROC PRINT data=&dsn;
		var &vars;
	RUN;
%MEND printdsn;
* Calling the macros by passing values for param list;
* remember the order is important;
%printdsn(sasuser.courses, course_code course_title days)
* if we need to pass NULL, we can just leave the value blank;
* let us pass null for vars below;
%printdsn(sasuser.courses)

* 8.2. Keyword Parameters;
* Key word params will also create Macro variabels automatically;
* Key=Value pair like definition;
* Order of mentioning the parameter is not a problem here;
* Values defined for the parameters in Macro becomes the default value if that particular param is not passed in Macro call;
%MACRO printdsn(dsn=sasuser.courses,vars=course_code course_title days);
	PROC PRINT data=&dsn;
		var &vars;
	RUN;
%MEND printdsn;
* calling the macros by passing the parameters in the form of Key=value pair and order doesnt matter here;
* In below macro call let us try to access some other dataset;
* Param value sent through macro call will override the default value set in macro definition;
%printdsn(dsn=sasuser.schedule, vars=teacher course_code begin_date)
* if no parameter is passed then, default value mentioned as part of key=value in Macro will get picked;
%printdsn()

* 8.3. Mixed Parameters;
* Can create Macro with both Posiotional and Keyword parameter;
* Very import to remember that - positional parameter must be listed before any key word parameter;
%MACRO printdsn(dsn,vars=course_code course_title days);
	proc print data=&dsn;
		var &vars;
	RUN;
%MEND;
* if we define a mixed parameter then, even when we call a macro positional param should be listed before keyword value;
%printdsn(sasuser.courses)
* or can list the full param list too;
%printdsn(sasuser.schedule, vars=teacher course_code begin_date)
* or both can be keyword param too;
%printdsn(dsn=sasuser.schedule, vars=teacher course_code begin_date)
* Passing no position parameter;
%printdsn() * This will through error;

* 8.4. /PARAMBUFF;
* help to create functions with dynamic set of varying parameters;
* thus, we can create a macro that can accept varying number of parameters at each invocation;
* /PARAMBUFF assigns entire list of parameter values in a macro call, in a name-style invocation;
* &syspbuff = used to display the paramaters that are specified in the macro call;
* Do not bother if you dont understand this program for now;
%macro printz/PARMBUFF;
	%PUT Syspbuff contains: &syspbuff;
	%let num=1;
	%let dsname=%scan(&syspbuff, &num);
	%do %while(&dsname ne);
		PROC PRINT DATA=sasuser.&dsname;
		RUN;
		%let num=%eval(&num+1);
		%let dsname=%scan(&syspbuff, &num);
	%end;
%mend printz;
* let us do a dynamic call to above macro created;
* trying to pass 2 param, which is the name of 2 different dataset which we would like to print;
%printz(courses, schedule)
* trying to pass 1 param, which is the name of 1 dataset which we would like to print;
%printz(courses)

* 9. Understanding Symbol Table;
* Macro variables values processed by Macro Processors are stored in a symbol table;
* There are two types of symbol tables:
	1. Global Symbol Table - Defined outside the Macros 
	2. Local Symbol Table - Defined inside the Macros;

* 9.1. Global Symbol Table;
* This symbol table stores both:
	1. Automatic Macro Variable 
	2. User Defined Macro Variable;
* Thus even the MV created through %LET is stored in GLOBAL symbol table;
* Global MV can be created using:
	1. %LET statment defined outside the macro definition
	2. SYMPUT in a DATA step
	3. SYMPUTX in a DATA step
	4. SELECT stmt with INTO clause in PROC SQL
	5. %GLOBAL statement;
/* %GLOBAL <MV1> <MV2>; 
	1. Can create one or more global MV seperated by a space
	2. MV can only be defined and not assigned, they are assigned with NULL value as default, %LET is used to assign values
	3. Can be used both inside and outside the Macro Definitions
	4. It has no effect on MV that already exists in symbol table, it means if symbol table already had MV defined, then only SAS will bother in updating its value rather than focussing on re-creation */
%macro printdsn;
	%global dsn vars;
	%let dsn=sasuser.courses;
	%let vars=course_title course_code days;
	PROC PRINT data=&dsn;
		var &vars;
	RUN;
%mend;
* Cheking the values for dsn and vars, this time no value would have been in global symbol table;
%PUT &dsn &vars;
* calling the macros;
%printdsn()
* Cheking the values for dsn and vars again, now value must have been assigned in global symbol table;
%PUT &dsn &vars;
* %SYMDEL option;
* It is used to delete a MV from a global symbol table;
%SYMDEL dsn vars;
* Re-Cheking the values for dsn and vars after deletion;
%PUT &dsn &vars;

* 9.2. Local Symbol Table;
* Generally created when you pass the parameter list during the macro call;
* Also when we create explicit local variables during macro executions;
* Life of LOCAL macro variable is only till the macro executes;
* LOCAL Macro Variable can be created using:
	1. %LET used wintin a macro statement
	2. SYMPUT used witin a macro statement
	3. SYMPUTX used within a macro statement
	4. SELCT with INTO in PROC SQL used within a macro statement
	5. using the %LOCAL statement;
* When creating Macro variable during execution useing SYMPUT or SYMPUTX, if Local Symbol table exist wil get stored there;
* If there is no local symbol table, then MV created out of SYMPUT and SYMPUTX gets stored in global symbol table;
* LOCAL and GLOBAL symbol tables should have same name for MV but can carry different values;
%let dsn=sasuser.courses; * this is a global MV;
%macro printdsn;
	%local dsn;
	%let dsn=sasuser.register; * this is local MV;
	%PUT The value of DSN inside peintdsn is &dsn; * fetches from LOCAL symbol table;
%mend printdsn;
* callin the macro;
%printdsn
%PUT The value of DSN inside peintdsn is &dsn; * fetches from GLOBAL symbol table;
* Thus MV defined inside Macros are called LOCAL MV and gets stored in Local symbol table;
* Those MV which are defined outside Macros are GLOBAL MV and its values get fetched from Global symbol table;
* If %LET or & is used in open code, then check is only in global symbol table;
* Very important, local symbol table get created only when the SAS is in executing mode;

* 9.3. Rules for Creating and Updating the variables;
* 9.3.1. For MV creation and value assignment;
* Step-1: Check in Local Symbol Table, if MV exist already then update, else step-2;
* Step-2: Check in Global Symbol Table, if MV exist already then update, else step-3;
* Step-3: Macro Processor create MV in Local Symbol Table and assign value to it;

* 9.3.2. For fetching values from MV;
* Step-1: Check in Local Symbol Table, if MV exist already then fetch, else step-2;
* Step-2: Check in Global Symbol Table, if MV exist already then fetch, else step-3;
* Step-3: Macro Processor returns the token to word scanner and warning message is written in SAS log;

* 9.3.3. Multiple Local Symbol Table;
* Multiple local symbol table exist concurrently during macro execution if there is a nested macro;
* Thus, multiple local symbol table is created when macro program is nested;
%MACRO outer;
	%local varix;
	%let varix=one;
	%put &varix;
	%inner
%MEND outer;

%MACRO inner;
	%local variy;
	%let variy=&varix;
	%put &variy;
%MEND inner;
* case-1: when varix=zero;
%let varix=zero;
%outer;
* Multiple local symbol table gets created whrn different macro start to execute;
* However, the birth of local symbol table is when macro starts to execute and ends when macro execution completes;
* Thus, in a given SAS session, only values in Global Symbol table stays in taact untill that SAS session;
* WHile other local symbol table gets deleted whenever a macro completes its execution cycle;

* 10. MPRINTNEST | NOMPRINTNEST;
* it is a SAS option command;
* MPRINTNEST will allow the macro nesting information to be written to the SAS log;
* It doesnot imply on the setting of MPRINT, we need to set both MPRINT and MPRINTNEST to display nested information in log;
%MACRO outer;
	%put this is outer;
	%inner
%MEND outer;
%MACRO inner;
	%put this is inner;
	%inrmost
%MEND inner;
%MACRO inrmost;
	%put 'This is inner most';
%MEND inrmost;
* for some reason mprintis not getting displayed in SAS log;
* I think from SAS 9 MPRINTNEST option is removed and same is implemented as part of MLOGICNEST;
OPTIONS MPRINT MPRINTNEST;
%outer

* 11. MLOGICNEST | NOMLOGICNEST;
* Even this is an OPTIONS command;
* It is the MPRINTNEST implementation in SAS 9 version;
* Allow the macro nesting information to be displayed in the MLOGIC output in SAS log;
%MACRO outer;
	%local varix;
	%let varix=one;
	%inner
%MEND outer;
%MACRO inner;
	%local variy;
	%let variy=&varix;
%MEND inner;
%let varix=zero;
%outer;
%MACRO inrmost;
	'This is the text of the PUT statement'
%MEND inrmost;
* remember MLOGIC must be complimented with MLOGICNEST;
OPTIONS MLOGIC MLOGICNEST;
%outer
* Let us reset the options;
OPTIONS NOMLOGIC NOMLOGICNEST;

* 12. Processing Statement Conditionally;
* Can use macros to control conditional execution of statements;
/* %IF <expression> %THEN; <1-line-stmt>; %ELSE <1-line-stmt>; */
* if we need to handle more than one line in IF statement, need to use %DO and %END stmt;
/* %IF <Expression> %THEN %DO; <multiple-line-stmt> %END; %ELSE %DO; <multiple-line-stmt>; <END>; */
* If the expression is resolved to 0 then it goes into else loop;
* if the expression is resolved anything other than 0 & being an integer it goes into if loop;
* If expression is resolved to NULL or any non-integer value SAS throws error;
* Remember %IF-%THEN-%DO-%END-%ELSE-%DO-%END can be used only inside the MACRO program;
* Very important - comparison made in IF expression is case sensitive;

* 12.1. %IF - %THEN Compared to IF-THEN;
* There is a considerable difference between data step IF-THEN-ELSE and Macro based %IF-%THEN-%ELSE;
* %IF-%THEN-%ELSE (M-IF) is used only in Macro Program, while IF is used in Data step program;
* M-IF executes during macro execution, while IF is executed during the DATA step execution;
* M-IF uses macro variable in logical expression, while IF uses DATA step variables in logical expression;
* M-IF determines what text to be copied to input stack, while IF determines what DATA step stmt shoul be executed;
%macro choice(status);
	data fees;
		set sasuser.all;
		%IF &status=PAID %THEN %DO;
			where paid='Y';
			keep student_name course_code begin_date totalfee;
		%END;
		%ELSE %DO;
			where paid='N';
			keep student_name course_code begin_date totalfee latechg;
			latechg=fee*.10;
		%END;
		/* adding the local surcharge */
		* This is a data step IF-ELSE-condition;
		if location='Boston' then totalfee=fee*1.06;
		else if location='Seattle' then totalfee=fee*1.025;
		else if location='Dallas' then totalfee=fee*1.5;
		RUN;
%mend choice;

* calling the macro;
options mprint mlogic;
%choice(PAID)
* Have an habit to check the logs, mlogic option will solve all macro expressions and display the same in SAS logs;
* if in case there is a error in macro, then macro processor will pick the error and display the same in SAS logs;
PROC PRINT DATA=fees;
RUN;

* 13. Macro execution with conditional Processing;
* 'WHERE ALSO' is a SAS operator in PROC FREQ used to add additional where conditions;
%macro attend(crs, start=01jan2001,stop=31dec2001);
	%let start=%upcase(&start);
	%let stop=%upcase(&stop);
	PROC FREQ data=sasuser.all;
		where begin_date between "&start"d and "&stop"d;
		table location/nocum;
		title "Enrolment from &start to &stop";
		%if &crs= %then %do; * &crs= means, the expression is true when value passed is NULL;
			title2 "for all courses";
		%end;
		%else %do;
			title2 "for course &crs only";
			where also course_code="&crs";
		%end;
	RUN;
%mend attend;
* calling the macro;
%attend(C003) * %if condition gets executed;
* Calling the macro with different value;
%attend(start=01jul2001)

* 13.2. Conditionaly specifying only the part of the statement;
%MACRO counts(cols=_all_, rows=,dsn=&syslast);
	title "Frequency counts for %upcase(%dsn) data set";
	PROC FREQ data=&dsn;
		tables
		%if &rows ne %then &rows *;
		&cols;
	RUN;
%MEND counts;
* Thus doing dynamic changes to a PROC FREQ procedure;
* tables row*col if row is passed as param and 2-way table is created;
* tables col if row value is not passed as param and 1-way table is created; 
* Calling the macro with both ROW and Col;
%counts(dsn=sasuser.all, rows=course_number, cols=paid)
* calling the macro with only passing col value;
%counts(dsn=sasuser.all, cols=paid)

* 14. Processing Statement Iteratively;
* %DO - %TO - %BY - %END;
* With iterative %DO statement we can repeatedly:
	1. Execute macro programming code
	2. Generate SAS Code;
* This is like FOR statement in SAS;
/* 
	%DO i=1 TO 10 %BY 1; 
		<statements>; 
	%END;
*/
* %DO and %END are valid only inside the macro definition;
* Index variable (i in above sample code) is created in local symbol table, if it doesnt appear in any other symbol table;
* Can use macro loop to create and display a series of macro variable;
options nomlogic;
* As part of below DATA step program, we are creting few Macro Variabels for Teachers and 1 MV for count;
* All these MV are stored in GLOBAL Symbol Table;
DATA _NULL_;
	set sasuser.schedule end=no_more;
	call symput('teacher'||left(_n_),(trim(teacher)));
	if no_more then call symput('count',_n_);
RUN;
* Using the MV stored in symbol table here in this MACRO program;
%MACRO putloop;
	%local i; * it is a good practice to declare this explicitly, else there are chance for value to get updated by any other symbol table;
	%do i=1 %to &count;
		%put TEACHER&i is &&teacher&i;
	%end;
%MEND putloop;
* Calling or executing the macro;
%putloop

* Macro loop is also used to generate statements that can be placed inside a SAS program step;
%macro hex(start=1, stop=10, incr=1);
	%local i;
	data _null_;
		%do i=&start %to &stop %by &incr;
			value=&i;
			put "Hexadecimal form of &i is " value hex6.;
		%end;
	RUN;
%mend hex;
* Calling the macro;
* loop stops processing when the value of the index variable is 32;
%hex(start=20, stop=30, incr=2)

* Generating complete Steps;
%macro readraw(first=1999, last=2005);
	%local year;
	%do year=&first %to &last;
		data year&year;
			infile "raw&year..dat";
			input course_code $4. location $15. begin_date date9. teacher $25.;
		RUN;
		
		PROC PRINT data=year&year;
			title "Schedule classes for &year";
			format begin_date date9.;
		RUN;
	%END;
%MEND readraw;
* calling the macro;
%readraw(first=2000, last=2002)

* 15. Using Arithmatic and Logic Expression;
* %EVAL function is the main focus;
* this evaluates integer arithmetic or logical expressions;
* sequence of operators and operands forming set of instructions that are evaluated to produce a result;
/* %EVAL(arithmetic or logical expression); */
* This %EVAL function:
	1. Translate integer, strings and hexadecimal to integers
	2. translate tokens representing arithmetic, comparison and logical operator to macro-level operator
	3. performs arithmetic and logical operations;
* %EVAL doesnt covert these to numeric:
	1. numeric strings that contain period or E-notations
	2. SAS Date and time constant;
* %SYSEVALF is used to evaluate arithmetic and logical expressions using the floating point arithmetic;
* %SYSEVALF perform floating-point arithmetic and return a value that is formatted using BEST32 format;
* We know that macro automatically converts any objects to char objects;
* To insist SAS to consider an object or expression as arithmetic or logical evaluation we use EVAL() function;
* 15.1. EVAL() on logical expressions;
%PUT value= (10 lt 2); *Since there is no eval() whole text is considered as a sting and same get printed as value= (10 lt 2);
%PUT value=%eval(10 lt 2); *Due to EVAL() text inside eval (10 lt 2) is considered as logical expression and 0 is returned;
* 15.2. EVAL() on arithmatic expression;
%PUT value=10+2; * value=10+2 is printed as it is considering it has a whole string value;
%PUT value=%eval(10 + 2); * Due to EVAL() text inside eval (10 + 2) is considered as arithmatic expression and 12 is returned;
* 15.3. EVAL() in handling the Macro variables as arithmatic or logical function;
%LET counter=2; * here counter is considered to hold a char 2;
%LET counter=%eval(&counter+1); * however, dur to eval counter gets changes to value 3, but 3 is internally stored as char for counter;
%PUT counter=&counter; * value 3 is printed;

%LET numer=2;
%LET denom=8;
%PUT value=%eval(&numer/&denom); * remainder is evaluated, which will be 0;

%LET numer=2;
%LET denom=8;
%PUT value=%eval(&numer/&denom*&denom);* value will be 0;
%PUT value=%eval(&denom*&numer/&denom);* value will be 2;

%LET real=2.4;
%LET int=8;
%PUT value=%eval(&real+&int);* will give NULL and through error, because EVAL() cannot handle period, E-notations and Date-time constants;

* 16. Automatic Evaluation;
* %SYSEVALF is the only macro function that can evaluate logical expression that contain floating point or missing value;
* Macro function or statement that require a numeric or logical expression automatically involkes %EVAL function;
* These includes %SCAN, %SUBSTR and even %IF-%THEN statements an more;
%PUT value=%SYSEVALF(&real+&int); * erro shown above is resolved using the %SYSEVALF() function;
* another example;
%macro figureit(a,b);
	%let y=%sysevalf(&a+&b);
	%PUT The result with selfevalf is: &y;
	%PUT BOOLEAN conversion: %SYSEVALF(&a+&b, boolean);
	%PUT CEIL conversion: %SYSEVALF(&a+&b, ceil);
	%PUT FLOOR conversion: %SYSEVALF(&a+&b, floor);
	%PUT INTEGER conversion: %SYSEVALF(&a+&b, integer);
%mend figureit;
* calling the macro;
%figureit(100,1.59)



