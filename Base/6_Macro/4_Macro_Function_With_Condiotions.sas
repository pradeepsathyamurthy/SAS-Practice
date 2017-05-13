* Use a macro with conditional logic;
* Using the System Variable for report generation;
* %IF %THEN %DO %ELSE %IF;

options ls=64 nodate pageno=1 mprint;

* Define the macro;
%MACRO daily_reports;
   %IF &SYSDAY = Friday %THEN %DO; *<- Change the value of SYSDAY based on your need, i am executing this program on Friday;
      proc print data=flowersales;
         format sale_date WORDDATE18.;
         title 'Friday Report: Current Flower Sales';
      run;
   %END;
   %ELSE %IF &SYSDAY = Tuesday %THEN %DO;
      proc means data=flowersales mean min max;
         class variety;
         var quantity;
         title 'Tuesday Report: Summary of Flower Sales';
      run;
   %END;
%MEND daily_reports;

data flowersales;
   infile "c:/datasets/tropical-sales.txt";
   input custid $4. @6 sale_date MMDDYY10. @17 variety $9. quantity;
run;

* Invoke the macro;
%daily_reports;

run;
quit;
