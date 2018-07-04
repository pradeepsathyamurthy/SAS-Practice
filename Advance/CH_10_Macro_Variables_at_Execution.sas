/* Chapter-10 Processing Macro Variable at Execution Time */
* In Ch-9 we generally saw how to create a Macro Variable during the Compilation time;
* Studied how macro processor handles a Macro Variable;
* Here we will study how a macro variable can be accesses and processed during execution time;
* We will study how to use Macro variable during the execution of:
	1. Data Step
	2. PROC SQL step
	3. SCL Program;
* Main focus will be on Data step and PROC SQL only;

* 1. Introduction
* Macro Facility performs its task before SAS program executes due to Macro Processor;
* Informtion provided by macro facility does not depend on values computed during execution;
* Sometimes it is needed to create Macro Variable during execution;
* This chapter is about creating and using macro variable during he execution of DATA STep and PROC SQL steps;
* Usage with SCL program is given less weightage;

* 2. Creating Macro Variable during Data Step Execution - SYMPUT(arg1, arg2) is the focus;
* Sample Program to look at the need of Macro Variable during execution;
PROC PRINT data=sasuser.all noobs;
	var course_number course_code course_title paid;
RUN;
QUIT;
* Sample program as in book for section 2;
option symbolgen; * Used to trace the value of macro variables;
%LET crs_num=3;
DATA REVENUE;
	SET sasuser.all END=final_rec;
	where course_number=&crs_num;
	total+1;
	if (paid='Y') then paidup+1;
	if final_rec then do;
		put total= paidup=;
		if (paid < total) then do;
			%LET ftnote="All Students Not Paid!!!";
		end;
		else do;
			%LET ftnote="All Student Paid!!!";
		end;
	END;
RUN;
QUIT;
* Printing the dataset newly created;
PROC PRINT data=revenue;
	title "Payment status for course &crs_num";
	var student_name student_company paid;
	footnote "&ftnote";
RUN;
QUIT;
* From above program we see the output in footnote is wrong;
* We see there are many students who hasn't paid the fees yet, still footnote prints all students paid;
* This is due to the macro processing happening before the Datastep execution;
* Macro Processor executes macro language statement before any SAS language statements are executed;
* In the above program first the %LET statements inside the DATA Step is passed to macro processor;
* Macro Processor then create a macro variable in the symbol table and assign value "All Student Not Paid" to it;
* Word scanner then continues and find another %LET statement and assign the value "All Styudent Paid" in sysmbol table;
* Thus, these macro processing happened and values are kept in symbol table;
* When the RUN stmt in DATA step is found, SAS completes the DATA steps and try to execute the DATA step;
* During this execution of DATA step, none of the %LET statement are included (as they are already processed);
* Thus, the latest value from sysmbol table is referred and passed as macro value;
* It is because of the above reason we got the wrong results;

* 3. SYMPUT routine;
* general format is: CALL SYMPUT(arg1, arg2);
* arg1 = Name of the macro variable;
* arg2 = Value for the macro variable, value can be:
			1. Literal value enclosed in ""
			2. Data step variable
			3. Data step expression;
* Thus, CALL SYMPUT will create a new Macro Variable and assign a value to it during execution;
* If the MV already exists, and if we try to update the value, then old value get reset;
* Macro variable is not actually created and assigned a value untill DATA step is executed;
* Thus, we cannot reference this MV created out of SYMPUT by preceding it with & within the same DATA step in which it is created;

* 3.1 SYMPUT usage with literals;
* CALL SYMPUT(arg1, arg2);
* CALL SYMPUT('MV','<string>');
* arguments are enclosed in quotes;
* arg1 = Macro Variable and arg2 = literal value which is enclosed in "";
* Such SYMPUT functions allow to use the value assigned to Macro in DATA step, extend to PROC step in same SAS session;
* That is symbolgen tables are not updated untill DATA step is executed;
* Re-writing the above program and correcting the error;
%LET crs_num=3;
DATA REVENUE;
	SET sasuser.all END=final_rec;
	where course_number=&crs_num;
	total+1;
	if (paid='Y') then paidup+1;
	if final_rec then do;
		put total= paidup=;
		if (paidup < total) then do;
			CALL SYMPUT('ftnote','All Students Not Paid!!!');
		end;
		else do;
			CALL SYMPUT('ftnote','All Students Paid!!!');
		end;
	END;
RUN;
QUIT;
* Printing the dataset newly created;
PROC PRINT data=revenue;
	title "Payment status for course &crs_num";
	var student_name student_company paid;
	footnote "&ftnote";
RUN;
QUIT;
* IN above program the value of macro variable ftnote was depending on value of Data step variable 'paidup';
* Thus, value for macro variable gets created and assigned value after the execution of Data step;

* 3.2 SYMPUT usage with Data step Variables;
* CALL SYMPUT(arg1, arg2);
* CALL SYMPUT('MV',);
* arg1 = Macro Variable and arg2 = Data step variable used in datastep;
* Data step variable can have max 32K characters and any leading or trailing blanks are also stored in macro variable;
* Values of numeric variables are converted automatically to character value using BEST12. format;
* let us rephrase the program;
%LET crs_num=3;
DATA REVENUE;
	SET sasuser.all END=final_rec;
	where course_number=&crs_num;
	total+1;
	if (paid='Y') then paidup+1;
	if final_rec then do;
		CALL SYMPUT('numpaid',paidup);
		CALL SYMPUT('numstu',total);
		CALL SYMPUT('crsname',course_title);
	END;
RUN;
QUIT;
* Printing the dataset newly created;
PROC PRINT data=revenue;
	title "Fee status for &crsname (#&crs_num)";
	var student_name student_company paid;
	footnote "Note: &numpaid Paid out of &numstu students";
RUN;
QUIT;
* SYMPUTX routine - Similar to SYMPUT + Removes leading and trailing blanks from both args;
%LET crs_num=3;
DATA REVENUE;
	SET sasuser.all END=final_rec;
	where course_number=&crs_num;
	total+1;
	if (paid='Y') then paidup+1;
	if final_rec then do;
		CALL SYMPUTX('date',put(begin_date,mmddyy10.));
		CALL SYMPUTX('due',put(fee*(total-paidup),dollar8.));
		CALL SYMPUTX('crsname',course_title);
	END;
RUN;
QUIT;
* Printing the dataset newly created;
PROC PRINT data=revenue;
	title "Fee status for &crsname (#&crs_num) held &date";
	var student_name student_company paid;
	footnote "Note: &due in unpaid fees";
RUN;
QUIT;

* 3.3 SYMPUT usage with Data step Expression;
* CALL SYMPUT(arg1, arg2);
* CALL SYMPUT('MV','MV');
* arg1 = Macro Variable and arg2 = Data step expression used in datastep;
* arg2 is evaluated according to following rules:
	1. Numeric expression are converted to char using BEST12. format 
	2. Result value size is upto 32K characters
	3. Leading and Trailing blanks are stored in macro variable;
* In the below program:
	LEFT() used to left justify the values
	TRIM() Removes the trailing blanks, it is a DATA step expression;
%LET crs_num=3;
DATA REVENUE;
	SET sasuser.all END=final_rec;
	where course_number=&crs_num;
	total+1;
	if (paid='Y') then paidup+1;
	if final_rec then do;
		CALL SYMPUT('numpaid', trim(left(paidup)));
		CALL SYMPUT('numstu', trim(left(total)));
		CALL SYMPUT('crsname', trim(course_title));
	END;
RUN;
QUIT;
* Printing the dataset newly created;
PROC PRINT data=revenue;
	title "Fee status for &crsname (#&crs_num)";
	var student_name student_company paid;
	footnote "Note: &numpaid Paid out of &numstu students";
RUN;
QUIT;

* 4. PUT function;
* Value of Macro Variable is always a character string;
* SYMPUT also do automatic numeric to character conversion;
* PUT function is used to have some explicit control over this numeric to character conversion;
* Thus, it controls the FORMAT of the data;
* PUT(arg1, arg2) where
	arg1= Source
	arg2= SAS format;
* Thus, a PUT function is used to control the format of a Macro variable;
* PUT function is mostly used with other parent function;
%LET crs_num=3;
DATA REVENUE;
	SET sasuser.all END=final_rec;
	where course_number=&crs_num;
	total+1;
	if (paid='Y') then paidup+1;
	if final_rec then do;
		CALL SYMPUT('crsname', trim(course_title));
		CALL SYMPUT('date', put(begin_date, mmddyy10.));
		CALL SYMPUT('due', trim(left(put(fee*(total-paidup),dollar8.))));
	END;
RUN;
QUIT;
* Printing the dataset newly created;
PROC PRINT data=revenue;
	title "Fee status for &crsname (#&crs_num) held &date";
	var student_name student_company paid;
	footnote "Note: &due in unpaid fees";
RUN;
QUIT;

* 5. Creating multiple macro variable with CALL SYMPUT;
* We can create multiple macro variable during data step execution;
DATA _NULL_;
	set sasuser.courses;
	call symput(cource_code, trim(course_title));
RUN;
%PUT _USER_;

%LET crsid=C005;
PROC PRINT data=sasuser.schedule noobs label;
where course_code="&crsid";
var location begin_date teacher;
title1 "Schedule for &C005";
RUN;

* 6. Referencing Macro Variable Indirectly;
* We can code more efficient program in SAS using an indirect reference;
* Forward Re-scan rule;
* According to frwd rescan, need to use three & in front of macro variable name when its value matches the name of the second MV;
* 1. When multiple & or % sign precedes a name token, macro processor resolve two && to one & and rescan the reference;
* 2. To re-scan a reference, macro processor scans and resolves tokens from left to right from point where multiple & sign coded untill no more trigger can be resolved;
* Thus, indirect reference resolves to the value of the second macro variable;
%LET crsid=C005;
PROC PRINT data=sasuser.schedule noobs label;
where course_code="&crsid";
var location begin_date teacher;
title1 "Schedule for &&&crsid";
RUN;
* You can use 2 & in a reference when the value of one macro variable matches part of the name of the second macro variable;

* 7. Obtaining Macro Variable value during Data step Execution - SYMGET();
* So far we where creating Macro variables and assigning values to it during the time of execution;
* Now, we would like to obtain value from a existing Macro variable during execution;
* SYMPUT() - Create macro variable in data step;
* SYMGET() - Returns the value of the existing macro variable;
* SYMGET fetches value for MV from Global symbol table;
Data Teacher;
	set sasuser.register;
	length Teacher $ 20;
	teacher=symget('teach'||left(course_number));
RUN;
* Validating the same using PRINT proc;
PROC PRINT data=teacher;
	var student_name course_number teacher;
	title "Teacher for Each registered student";
RUN;

* 8. Creating Macro Variable during PROC SQL step execution - INTO with NOPRINT and declare macro variable with :;
* Can create or update macro variable during the execution of PROC SQL step;
* can be used only in SELECT query;
* Cannot be used while creating or modifying a table;
* Use NOPRINT with PROC SQL, because we dont need to print values when we create or update the macro variables;
* PRINT is the default setting;
PROC SQL NOPRINT;
	select sum(fee) format=dollar10. INTO :totalfee
	from sasuser.all;
QUIT;
%let totalfee=&totalfee;
%put &totalfee;
PROC MEANS data-sasuser.all sum maxdec=0;
	class course_title;
	var fee;
	title "Grand total for all courses is &totalfee";
RUN;
QUIT;
* These INTO clause do not TRIM leading and trailing blanks;
* However, %LET removes any leading or trailing blanks that are stored;

* 9. Creating multiple macro variables with PROC SQL during execution;
PROC SQL;
	select course_code, location, begin_date format=mmddyy10.
	into :crsid1-:crsid3,
		 :place1-:place3,
		 :date1-:date3
	from sasuser.schedule
	where year(begin_date)=2002
	ORDER BY begin_date;
QUIT;
* Example-2;
PROC SQL noprint;
	select count(*) into :numrows
	from sasuser.schedule
	where year(begin_date)=2002;
	%let numrows=&numrow;
	%put There are &numrows courses in 2002;
	select course_code, location, begin_date format=mmddyy10.
	into :crsid1-:crsid&numrows,
		 :place1-:place&numrows,
		 :date1-:date&numrows
	from sasuser.schedule
	where year(begin_date)=2002
	order by begin_date;
%PUT _user_l
quit;

*10. Creating delimited list of values;
* Can use the alternative form of INTO clause to take all of the value of a column and concatenate them into the value of one macro variable;
* SEPARATED BY is used;
PROC SQL noprint;
	select distinct location into :sites SEPARATED BY ''
	from sasuser.schedule;
QUIT;
* using the same;
PROC MEANS data=sasuser.all sum maxdec=0;
	var fee;
	title1 'Total Revenue';
	title2 "From course site: &sites";
RUN;

* 11. Working with PROC SQL Views;
PROC SQL;
	CREATE VIEW subcrsid as 
	select student_name, student_company, paid
	from sasuser.all
	where course_code="&crsid";
QUIT;
* Better apporach would be use the SYMGET function;
PROC SQL;
	CREATE VIEW SUBCRSID as 
		select student_name, student_company, paid 
		from sasuser.all
		where course_code=symget('crsid') and cource_number=input(symget('crsnum'),2.);
* Testing;
%let crsid=C003;
PROC PRINT data=subcrsid noobs;
	title "Status of students in course code &crsid";
RUN;
* PROC SQL does not perform automatic conversion;
* Must use the INPUT function to convery macro variabel value to numeric if it is compared to a numeric variable;

* 12. Using Macro variable in SCL - SAS Component Language;
*SYMPUTN - Create macro variable durin execution of the scl program and assign numeric value to it;
*SYMGETN - Obtain numeric value of a macro variable during execution of an SCL Program;
