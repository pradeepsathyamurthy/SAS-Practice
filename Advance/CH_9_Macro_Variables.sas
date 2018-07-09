* Pradeep Sathyamurthy - 2018;

/* Macro Variables */
/* Macro variables are SAS variables which are used to make a SAS program more flexible and dynamic */
/* Marcro Variables are part of Marcro Facility */

/* Macro Facility */
/* We can think Macro Facility as User defined Functions in Marcro */
/* They are SAS Functions which are binded with several individual codes */
/* Before we go into Marco facility, it is important to understand the macro Variables, its definition and usages */

* Creating a Macro Variables;
/* Macro Variables are of 2 Types:
	1. Automatic Macro Variables (MV = Macro Varibles) = These are defined by SAS itself, in built in SAS
	2. User Defined MV = These are variables created by Users */

* Defining & Referencing a Variable;
* Any Macro keyword need to be prefixed with % sign to help system identify that they are macro key word;
* LET, PUT are few SAS Macro Key words;
* you can define a SAS Variable using %LET sign and reference the same using & sign;

* e.g. defining a macro variable today_date, here today_date is a user defined variable and sysdate is a automatic variable;
* %LET is used to define a MV and %PUT is like a print statement in Macros which will print the o/p in SAS log;
%LET today_date = &sysdate;
%PUT &today_date;
RUN;
QUIT;

/* How SAS Works with Macro definitions - SAS Processing Macro Variables */
* SAS Macro Program > Input Stack > Word Scanner > Tokenize > Compiler > Identify Marcro Key Words (Macro Triggers) > Macro Processor > Return the result;
* Input Stack = Holds the whole code until it sees a semicollon;
* Word Scanner = It tokenized the SAS statements into individual words;
* Tokens = Differet types of tokens are: Literal(strings enclosed in '' or ""), Number, Name, Special (* / **) and Macro Triggers (% &);
* Compiler = These analyze if the token need to be processed directly or identify macro triggers;
* Macro Triggers = These will send the tokens to Macro Processor, generally & and % are considered to be Macro triggers;
* Macro Processor = These will process the Macro and produce output;

* Creating or defining a macro Variable;
* You can create a MV using %LET statement, there shouldn't be a space between % and LET, because space is considered as word break by word scanner;
* Also, strings need not be defined in double quotes;
* If strings are defined with double quotes, even double quotes are printed in sas log along with text;
* This is because macro convert all text to characters by default;
* All these variables created get stored in Global Symbol Table;
* It is advisable to end with RUN and QUIT statement;
%LET city = Chicago;
%LET dob = 08May1985;
%LET amount = 1000;
RUN;
QUIT;

* Referencing a Macro Variable;
* For this we use & sign and place the variable name next to & to note the system that its a Macro Variable reference;
* %PUT is like an output statement in SAS, used to debug any Macro variable;
* it let us reference and print the above defined MV;
%PUT &city;
%PUT &dob;
* When you use " " in the PUT statement, they are printed as it is, that is values are printed along with "";
* It is not necessary to enclose a macro reference inside a " " even though its values are char or numeric;
* However, if at all it needs to be enclosed in a quotes for e.g. while defining Title or Footnote
* Use only double quotes "" and not the single quotes '' ;
%PUT "&amount"; * atleast this MV get execute but with "" in o/p;
%PUT '&amount'; * with '' macro variable is not even recognized;
%PUT &amount;
RUN;
QUIT;

* Referencing a Macro varibale in Title;
* Remember if you reference any MV which are not yet ceated system will only through warning;
* However, if the statement is invalid, system will through error;
%LET table_name = Payrollmaster;
TITLE "Table listed is &table_name";
PROC PRINT DATA=sasuser.&table_name;
RUN;
QUIT;

* Automatic Variables;
* These are created when SAS is invoked;
* Stay untill SAS session exist;
* They are global in nature and resides in symbol table;
* Difference between global and local symbol table will be discussed in later chapters;
* Below statement will take the whole statement as a big text and display it as it is because of the absence of & sign;
%put sysdate,sysdate9, sysday, systime, sysenv, sysscp, sysver, sysjobid;
* Remember to reference MV using the & sign;
%put &sysdate, &sysdate9, &sysday, &systime, &sysenv, &sysscp, &sysver, &sysjobid;
* these automatic MV are generally used with footnote to comment smething;
footnote "Printed on &sysdate9 &systime";
PROC PRINT DATA=sasuser.Payrollmaster;
RUN;
QUIT;

* User defined Macro Variable;
* User defined MV can be created using %LET statement as said above;
* User defined MV are always considered as char string in SAS, thus its case are maintained, Quotes stays in tact and expression are not evaluated;
* Leading and trailing spaces are not trimmed;
%LET name = Pradeep Sathyamurthy  ;
%LET name1 = ' Pradeep Sathyamurthy ';
%lET name2 = " Pradeep Sathyamuthy ";
%PUT &name,&name1,&name2;
* See how single quotes ' are handled in SAS;
* In case of apostaphy, double quotes saves the format of display;
%LET title = "Prady's Practice";
%LET start=;
%LET total=0;
%LET sum=1+3;
* Note this below two codes;
%LET x = varlist;
%LET  varlist = name age height;
RUN;
QUIT;
/* let us varify this using the %PUT statement  */
%PUT &name;
%PUT &name1; * Quotes are maintained, generally it should remove the leading and trailing space, but when in put it is not removing the space;
%PUT &title; * But even double quotes are printed along;
%PUT &start; 
%PUT &total; 
%PUT &sum; * just print 1+3 as text, because remember macro will convert text after macro to characters;
%PUT &x; 
%PUT &varlist;
run;
quit;

* Displaying Macro Variables in SAS Logs;

* 1. SYMBOLGEN;
* Since the value of variable is generated from Symbol table it is called SYMBOLGEN;
* Validating the Macro varibles present in symbol table - use SYMBOLGEN;
* SYMBOLGEN is primarily used to debug and monitor the value a MV carries;
* It is usually specified as a OPTIONS command;
OPTIONS SYMBOLGEN;
%PUT &name; * SYMBOLGEN gets triggered here to display the value MV name carries;
RUN;
QUIT;
* to stop the SYMBOLGEN we use the NOSYMBOLGEN;
OPTIONS NOSYMBOLGEN;
%PUT &name;
RUN;
QUIT;

* 2. %PUT;
* This is used as a optimal debugger, just like a print statement in SAS;
%PUT &name;
* it has other options to display all values stored as part of Symbol table;
%PUT _ALL_; *Displays all Automatic as well user defined MV from sysmbol table along with its current values;
%PUT _AUTOMATIC_; *Displays all Automatic MV from sysmbol table;
%PUT _USER_;
RUN;
QUIT;

* Macro Function to mask Special Characters - %STR and %NRSTR;
* %STR will say compiler that all the words inside this function are of string type - will mask the effect of ' " , . and semicollon;
* %STR will also mask blanks and logical operator;
* %NRSTR is same as STR, in addition it will mask or nullify the effect of macro trigger symbols like & and % ;
* However, main thing to note is that, the effect is masked during the compilation phase and not during execution;

* for e.g if you need to use ' or . or " you need to define value inside a "" else SAS will through exception;
* This will through error;
*%LET var1 = Sandy's; 
*%PUT &var1;
* to resolve this use "" or %STR;
%LET var2 = "Prad's Car is Alto";
%PUT &var2;
%PUT &VAR2; * Variable name is not case sensitive;
RUN;
QUIT;
* e.g. with semicolon to see how its effect is masked;
%LET var3 = %STR(Prady;s car is Alto);
%PUT &var3; /* this will not display the value properly, need to use "" */
run;
quit;

* However single quote needs to be used carefully;
* while using ' with %STR it should be accompanied with % that is %' like that;
%LET var4=%STR(HI Prad%'s car);
%PUT &var4;
run;
quit;

* %NRSTR to handle & and % in a marcro variable, it will mask the effect of & and % in MV;
%LET var5 = %STR(Pradeep & Sruthi); * this will work;
%PUT &VAR5;
%LET var6 = %STR(Pradeep &Sruthi); * this will cause issue as macro compiler treats &sruthi as a macro, howwer it is not defined;
%PUT &var6;
* to resolve this use the NRSTR function;
%LET var6 = %NRSTR(Pradeep &Sruthi); 
%PUT &var6;
* however, even here we need to use %' to declare single quotes;
%LET var4=%NRSTR(Hi Prad%'s car);
%PUT &var4;
run;
quit;

* %BQUOTE is used to handle ' without much hastle like without any %' as we do in %STR or %NRSTR;
* Masking effect takes place during execution and not compilation;
%LET var4=%BQUOTE(Hi Prady's car);
%PUT &var4;
run;
quit;

* %NRBQUOTE is same as %BQUOTE, however it also handles & and %;
* so, this can be used as the most convinent function to handle any special characters;
%LET var6 = %NRBQUOTE(Pradeep's &Sruthi's); * this will cause issue as macro compiler treats &sruthi as a macro, howwer it is not defined;
%PUT &var6;
run;
quit;

* Macro functions to manipulate Char strings;
* These functions are similar to DATA step functions but are different from each other;

* 1. %UPCASE - used to convert lower case char to upper case char;
%PUT %UPCASE(var6);
%PUT %UPCASE(&var6); * using the macro variable, displays results but through warning as there are some spl char;

* 2. %QUPCASE - Used to handle strings with special char, Mnemonics and Macro Trigger;
* Use this as a supreme function if your string has spl char and you need to convert it to upper case;
%PUT %QUPCASE(&var6); * This will convert the MV to upper case without throughing any Notes or Exceptions

* 3. %SUBSTR - Used to extract/slice part of string from a variable value based on position if mentioned;
%LET var7 = 05JAN2018;
%PUT %SUBSTR(&var7,3); * it will start from 3rd char and fetch the whole rest of the char in string;
%PUT %SUBSTR(&var7,3,3); * it will start from 3rd char but extract only 3 char from there on;
%PUT %SUBSTR(&var7,3,9); * here there is a index out of bound. However, rest of the char is displayed and a warning is thrown;

* 4. %QSUBSTR - handles macro triggers too;
%LET var8 = %BQUOTE(05JAN'2018);
%PUT %SUBSTR(&var7,3); * this will not produce proper needed result, SUBSTR will ignore any spl characters it faces;
%PUT %QSUBSTR(&var7,3); * this will produce a proper result by nullifying the effect of ' in MV;

* 5. %INDEX - returns the position of the matching value;
%PUT %INDEX(&var7,JAN); * returns the position 3 for the same;
%PUT %INDEX(&var7,jan); * matching is case sensitive, when no match value 0 is returned;

* 6. %SCAN - works like a find/search;
%LET dataset1 = SASUSER.PAYROLLMASTER;
%PUT %SCAN(&dataset1, 1, .); * this will search for first word before a period, thus returns SASUSER;
%PUT %SCAN(&dataset1, 2, .); * this will return the secon value after period;
%LET dataset2 = WORK.SAS.PAY.MAN;
%PUT %SCAN(&dataset2, 3, .); * this will return value pay, data in the 3 position with period as seperator;

* 7. %QSCAN - works like %SCAN + handles spl char, mnemonics and macro triggers;
%LET dataset3 = %BQUOTE(SAS'USER;PRADY.Data.dataset2);
%PUT %SCAN(&dataset3, 1, .); * value is displayed but not the desired value;
%PUT %QSCAN(&dataset3, 1, .);

* 8. %SYSFUNC - Used to execute other SAS function as part of macro facility;
%PUT %SYSFUNC("&SYSDATE, &SYSTIME - SALES Report"); * remember, this will give error message;
* &sysdate and &systime are not SAS functions, they are SAS Automatic macro variables;
* SAS Functions includes - DIF(), DIM(), HBOUND(), INPUT(), IORCMSG(), LAG(), LBOUND(), MISSING(), PUT(), RESOLVE(), SYMGET();
%PUT TODAYE(); * today() will be displayed as a char;
* To execute this as a SAS function, we use SYSFUNCT;
%PUT %SYSFUNC(TODAY()) - Sales Report; * This will not through error. However, format for today() will be a number;
%PUT %SYSFUNC(TODAY(), WEEKDATE.) - Sales Report; * including the FORMAT WEEKDATE. help to convert the todays date;

* 9. %QSYSFUNCT - Same as SYSFUNCT + handles blank spaces + spl char + mnemonics;
%PUT %SYSFUNC(left(%QSYSFUNC(TODAY(), weekdate.))); * almost similar to %SYSFUNC but handles spl char;

* Macro Variable References with TEXT;
* There are totally 3 ways a macro var can be referenced - Leading, Trailing and Adjacent;

* 1. Leading Reference with text - MV is lead by a text;
%LET month1 = JAN;
%PUT 2018of&month1;

* 2. Trailing Reference with text - MV occurs before a text;
* this needs to be used wisely, if needed with a space or with some spl char that are not part of name token to sperate the MV and other normal text;
* remember when compiler finds a % or & it is defined as macro statement and sent to macro processor, from & till a black space is fount it is considered as one single token;
%PUT &month1*1; * here * is not a part of month1 token, so this will be used by word scanner as a delimiter;
%PUT &month1 2018; * space is also a spl char;

* 3. Adjacent - Referencing two or more MV next to next;
%PUT &name&month1;

* Main things to remember wrt SAS Macro Variables;
* 1. SAS Macro variables (MV) are part of SAS Macro Facility;
* 2. MV converts text after it as char by default;
* 3. %LET used to define MV;
* 4. %PUT used to print MV, it has _ALL_, _AUTOMATIC_ and _USER_;
* 5. If Macro variable used in Titles use double quotes to resovle a macro;
* 6. Spl char, space and macro symbols are not automatically resolved by SAS;
* 7. %STR and %NSTR - helps to convert to string and mask effect of macro spl char during compilation time;
* 8. %BQUOTE and %NRBQUOTE - helps during exeution time;
* 9. %UPCASE and %QUCASE;
* 10. %SUBSTR and %QSUBSTR;
* 11. %INDEX;
* 12. %SCAN and %QSCAN;
* 13. %SYSFUNC;
