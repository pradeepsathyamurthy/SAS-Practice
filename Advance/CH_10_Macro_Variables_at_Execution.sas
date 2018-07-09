/* Chapter-10 Processing Macro Variable at Execution Time */
* In Ch-9 we generally saw how to create, access and process a Macro Variable during the Compilation time;
* Studied how macro processor handles a Macro Variable;
* Here we will study how a macro variable can be created, accessed and processed during execution time;
* We will study how to create and use Macro variable during the execution of:
	1. Data Step
	2. PROC SQL step
	3. SCL Program;
* Main focus will be on Data step and PROC SQL only;

* 1. Introduction
* Macro Facility performs its task before SAS program executes due to Macro Processor;
* Informtion provided by macro facility does not depend on values computed during execution;
* Sometimes it is needed to create Macro Variable during execution;
* This chapter is about creating and using macro variable during the execution of DATA Step and PROC SQL steps;
* Usage with SCL program is given less weightage;

* 2. Creating Macro Variable during Data Step Execution - SYMPUT(arg1, arg2) is the focus;
* Sample Program to look at the need of Macro Variable during execution;
PROC PRINT data=sasuser.all noobs;
	var course_number course_code course_title paid;
RUN;
QUIT;
* Sample program as in book for section 2;
options symbolgen; * Used to trace the value of macro variables;
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
* We see there are many students who hasn't paid the fees yet in dataset, still footnote prints all students paid;
* This is due to the macro processing happening before the Datastep execution;
* Macro Processor executes macro language statement before any SAS language statements are executed;
* In the above program first the %LET statements inside the DATA Step is passed to macro processor;
* Macro Processor then create a macro variable in the symbol table and assign value "All Student Not Paid" to it;
* Word scanner then continues and find another %LET statement and assign the value "All Styudent Paid" in sysmbol table;
* Thus, these macro processing happened and values are kept in symbol table;
* When the RUN stmt in DATA step is found, SAS compiles the DATA steps and try to execute the DATA step;
* During this execution of DATA step, none of the %LET statement are included (as they are already processed by macro processor);
* Thus, the latest value from sysmbol table is referred and passed as macro value;
* It is because of the above reason we got the wrong results;
* To avoid this we need a macro variable which will get created and get assigned with values at the time of execution;

* 3. Creating and assigning value of Macro Variable during SAS execution;
* SYMPUT routine;
* general format is: CALL SYMPUT(arg1, arg2);
* arg1 = Name of the macro variable;
* arg2 = Value for the macro variable, value can be:
			1. Literal value enclosed in ""
			2. Data step variable
			3. Data step expression;
* Thus, CALL SYMPUT will create a new Macro Variable and assign a value to it during execution;
* If the MV already exists, and if we try to update the value, then old value get reset;
* Macro variable is not actually created and assigned a value untill DATA step is executed;
* Below is a Very Important point;
* Thus, we cannot reference this MV created out of SYMPUT by preceding it with & within the same DATA step in which it is created;

* 3.1 SYMPUT usage with literals;
* CALL SYMPUT(arg1, arg2);
* CALL SYMPUT('MV','<string>');
* arguments are enclosed in quotes;
* arg1 = Macro Variable and arg2 = literal value which is enclosed in '';
* Such SYMPUT functions allow to use the value assigned to Macro in DATA step, extend to PROC step in same SAS session;
* That is symbolgen tables are not updated untill DATA step is executed;
* Re-writing the above program and correcting the error;
* That is why in the below program we see CALL SYMPUT doesn't get preceed with % signs and even the MV ftnore is not used anywhere inside DATA step;
* There is no involvement of macro processor here, unless the DATA step get executed;
* Only after DATA step get executed, value for MV in SYmbol table gets updated for ftnote based on the value of the data step variable whose value is present in PDV;
* Thus, when ever you want to create and assign macro variables in DATA STEP conditional statements use CALL SYMPUT routine;
options symbolgen;
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
* When you submit the above DATA step, only PDV gets created and there is no sign of log for macro variable created using CALL SYMPUT;
* We even see, there is no SYMBOLGEN entry in SAS log for the above MV created using CALL SYMPUT;
* Printing the dataset newly created;
* Now the value in PDV is referred before updating the MV value in Symbol Table;
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
* CALL SYMPUT('MV',data_step_var);
* arg1 = Macro Variable and arg2 = Data step variable used in datastep;
* Data step variable can have max 32K characters and any leading or trailing blanks are also stored in macro variable;
* Values of numeric variables are converted automatically to character value using BEST12. format;
* Thus, when you create a data step variable and if you want to pass it on as a macro variable during execution use below method;
* Let us rephrase the program;
OPTION SYMBOLGEN;
%LET crs_num=3;
DATA REVENUE;
	SET sasuser.all END=final_rec;
	where course_number=&crs_num;
	total+1;
	if (paid='Y') then paidup+1;
	if final_rec then do;
		CALL SYMPUT('numpaid',paidup);
		CALL SYMPUT('numstu',total);
		CALL SYMPUT('crsname',course_title); * This is the column value, in this e.g. this is course_tile value for course_number=3;
	END;
RUN;
QUIT;
* Printing the dataset newly created;
* Data variable created above in DATA step during execution stays untill the current SAS session in PDV;
* Thus, MV derive its value from PDV and gets stored in symbol table;
* We see not just the MV created during the Execution but also MV created during coompilation stage also exist in the symbol table;
PROC PRINT data=revenue;
	title "Fee status for &crsname (#&crs_num)";
	var student_name student_company paid;
	footnote "Note: &numpaid Paid out of &numstu students";
RUN;
QUIT;
* SYMPUTX routine - Similar to SYMPUT + Removes leading and trailing blanks from both args;
* PUT is used to have control on the format of Macro Variable;
* By default all MV are converted to Character using BEST12. format;
* But to take some control in this format conversion, we can make use of PUT SAS function;
* We are not talking about %PUT statement, we are talking about SAS function named PUT(var,<sas_format>);
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
* CALL SYMPUT('MV',Expression);
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

* 4. PUT() function;
* Value of Macro Variable is always a character string;
* SYMPUT also do automatic numeric to character conversion using the BEST12. format;
* PUT function is used to have some explicit control over this numeric to character conversion;
* Thus, it controls the FORMAT of the data;
* PUT(arg1, arg2) where
	arg1= Source
	arg2= SAS format;
* Thus, a PUT function is used to control the format of a Macro variable;
* PUT function is mostly used with other parent function;
* it must be enclosed within a (), like PUT(expr,<SAS_format>);
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
* This is nothing but using each column value as a macro variable;
* When DATA step executes for each row/observation, new Macro Variable is eaither created or updated;
* Be careful with the column name used, else you will not get the desired result;
DATA _NULL_;
	set sasuser.courses;
	call SYMPUT(course_code, trim(course_title));
RUN;
%PUT _USER_;

%LET crsid=C005;
PROC PRINT data=sasuser.schedule noobs label;
where course_code="&crsid";
var location begin_date teacher;
title1 "Schedule for &C005"; * this line will be made more efficient going forward using indirect reference;
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
* In the above program we see that we used one macro variable at multiple place to render different data;
* You can use 2 & in a reference when the value of one macro variable matches part of the name of the second macro variable;

* 7. Obtaining Macro Variable value during Data step Execution - SYMGET();
* So far we where creating Macro variables and assigning values to it during the time of execution;
* Now, we would like to obtain/get value from a existing Macro variable during execution;
* SYMPUT() - Create macro variable based on the latest value of PDV after the execution of Datastep;
* SYMGET() - Returns the value of the existing macro variable;
* SYMGET fetches value for MV from Global symbol table;
* Do not try to infer anything from below program, it is not a complete program, this is just to explain how to use SYMGET();
* Here we should assume that Global Symbol table already carry values for MV like Teach1, Teach2, Teach3, etc.,;
* Whose value we are trying to fetch during the Data Step execution;
* For experimentation I am trying to induce 2 macro variable in symbol table which will be referenced using SYMGET later;
%LET teach1=Prady;
%LET teach2=Sruthi;
Data teachers;
	set sasuser.register;
	length Teacher $ 20; * This is a derived variable;
	teacher=symget('teach'||left(course_number));
RUN;
* Validating the same using PRINT proc;
PROC PRINT data=teachers;
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
* Practice this;
PROC MEANS data=sasuser.all sum maxdec=0;
	class course_title;
	var fee;
	title "Grand total for all courses is &totalfee";
RUN;
QUIT;
* These INTO clause do not TRIM leading and trailing blanks;
* However, %LET removes any leading or trailing blanks that are stored;

* 9. Creating multiple macro variables with PROC SQL during execution;
* For each column value we declare its respective macro variable;
* Use the - to provide the range and seperate each macro variables using comma;
PROC SQL;
	select course_code, location, begin_date format=mmddyy10.
	into :crsid1-:crsid3,
		 :place1-:place3,
		 :date1-:date3
	from sasuser.schedule
	where year(begin_date)=2002
	ORDER BY begin_date;
QUIT;
* Testing the MV cretion;
%PUT &crsid1;
%PUT &CRSid3;
* Example-2, making the program more dynamic wrt to multiple MV creation;
PROC SQL noprint;
	select count(*) into :numrows
	from sasuser.schedule
	where year(begin_date)=2002;
	%let num_rows=&numrow;
	%put There are &numrows courses in 2002;
	select course_code, location, begin_date format=mmddyy10.
	into :crsid1-:crsid&num_rows,
		 :place1-:place&num_rows,
		 :date1-:date&num_rows
	from sasuser.schedule
	where year(begin_date)=2002
	order by begin_date;
%PUT _user_;
quit;

*10. Creating delimited list of values;
* Can use the alternative form of INTO clause to take all of the value of a column and concatenate them into the value of one macro variable;
* SEPARATED BY is used;
PROC SQL;
	select distinct location into :sites SEPARATED BY ' '
	from sasuser.schedule;
QUIT;
* testing the above value created;
%PUT &sites;
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

* POints to remember;
* So far we created MV during the compilation stage using %LET and accesing it using %PUT;
* Remember that Macro processing is done before the data step processing;
* If we need to create MV during the execution time, we need to use SYMPUT('<macro_name>',args2);
* args2 in SYMPUT can be:
	1. Literal string
	2. Data Step Variable
	3. A simple expression;
* SYMPUT is not a macro keyword, hence it is not prefixed with % with them;
* SYMPUT is picked by SAS at the time of execution and a MV mentioned in SYMPUT gets created;
* ..and its respective value mentioned in args2 will be updated in symbol table;
* However, macro variable stores its value as char type by default in sysmbol table using BEST12. format;
* PUT(MV,sas_format) is used to have some control in data type that get stored in symbol table;
* Similarly, if we need to fetch current value of a MV from a Symbol table use SYMGET(MV);
* Forward re-scan rule is very important concept, where && is always resolved to one & during execution, this is called indirect referensing;
* INTO keyword after colum specification  with : before MV, is used to create MV during PROC SQL execution;
* Multiple MV can be created for each column value like :MV_col1-:MV_col3, using INTO statement;
* MV can be used in VIEW execution too;
* SYMPUTN() and SYMGETN() is used in SAS Control Language (SCL);
