  * Uncomment the following link to generate comments in the log
  file on how the macro lines are expanded.  This line may
  or may not be useful;
options mprint;

%MACRO create_datasets(num_states=);

LIBNAME states 'C:\datasets\states-files';
%DO k = 1 TO &num_states;
   data state_data;
      infile 'C:\datasets\states-files\state&k.txt' dlm=',';
      length state $ 20;
      length city $ 20;
      input state $;
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
