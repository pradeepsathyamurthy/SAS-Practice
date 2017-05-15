* This is like assigning a value to a variable and using the variable else where using '&';
* It is not necessary that CALL SYMPUT needs to be defined only inside %MACRO;
* This is about macro variable;
* Use CALL SYMPUT to set macro variables in a data step that would write data to external file;
* SYMPUT is used to assign value to a marco variable inside a SAS command instead of defining it through %LET;
* Use call SYMPUT() and define the value inside the symput function;

options ls=64 nodate pageno=1;

* Read dataset;
* Macro has nothing to do here;
data flowersales;
   infile "c:/datasets/tropical-sales.txt";
   input custid $4. @6 sale_date MMDDYY10. @17 variety $9. quantity;
run;

* Sort dataset;
* Macro has nothing to do here as well;
proc sort data=flowersales;
   by descending quantity;

* Find biggest order and pass custid to a macro variable;
data _null_;
   set flowersales;
   if _n_ = 1 then call SYMPUT("selected_customer", custid); * <- Usage of SYMPUT() in DATA block to define a macro varibale ;
   else stop;
run;

proc print data=flowersales;
   where custid="&selected_customer";
   format sale_date WORDDATE18.;
   title "Customer &selected_customer Had the Largest Order";
run;

quit;
