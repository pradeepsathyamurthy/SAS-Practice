* 	Uncomment the following link to generate comments in the log
	file on how the macro lines are expanded.  This line may
  	or may not be useful;

options mprint;

*%MACRO create_datasets(num_states=);

LIBNAME states "C:\datasets\states-datasets"; * <- Error-1: Path for the libname should be in double quotes;
%DO k = 1 %TO "&num_states"; * <- Error-2&3: Since Condition is used inside macro, we need to use %TO and macro variable should be enclosed in "" ;
   DATA state_data;
      infile "C:\datasets\states-files\state&k..txt" dlm=','; * <- Error-4&5 Double Quotes and defining the macro variable properly ;
      length state $ 20;
      length city $ 20;
      input id state $ population; * <-Error-6 Variables to read is missing;
      dsname = transwrd(trim(state), ' ', '_');
      call symput("name", state);
      call symput("dsname", dsname);

      do i = 1 to 50;
         input rank city $ popul;
         output;
      end;
      keep i state;
   run;

   data states.&name;
      set state_data;
   run;

   proc print data=states.&dsname;
      title "Ten Largest Cities in &name";      
   run;
end;
%END;

create_datasets(numstates=50)

run;
quit;
