data test1;
	input x $;
	datalines;
pradeep*
;

data test2;
	set test1;
	y=substr(x,1,2);

proc print data=test2;

run;
quit;


