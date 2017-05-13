libname states "C:\datasets\states-files";
DATA state_data;
	infile 'C:\datasets\states-files\state29.txt' dlm=',';
	length state $ 20;
	length city $ 20;
	if _n_=1 then do;
		input state $;
		dsname = TRANWRD(trim(state), ' ', '_');
		call symput("name", state);
		call symput("dsname", dsname);
	end;
	else do i = 1 to 10;
		input rank city $ popul;
	 	output;
	end;
	keep rank city popul;
RUN;

DATA states.New_Hampsire;
      set state_data;
RUN;

PROC PRINT DATA=states.New_Hampsire;
	title "Ten Largest Cities in &name";
RUN;

