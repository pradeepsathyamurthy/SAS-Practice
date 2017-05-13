options mprint;

%MACRO create_datasets(num_states=);
libname states "C:\datasets\states-files";
%do k = 1 %to &num_states;
	DATA state_data;
		infile "C:\datasets\states-files\state&k..txt" dlm=',';
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

	DATA states."&dsname"; * <- see which works "&dsname" or just &dsname;
	      set state_data;
	RUN;

	PROC PRINT DATA=states."&dsname";
		title "Ten Largest Cities in &name";
	RUN;
%end;
%MEND create_datasets;

%create_datasets(num_states=50);
RUN;
QUIT;

