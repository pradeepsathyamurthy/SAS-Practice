/* Stacking or merging two datasets - use set operator with data set names*/
* Here we are trying to merge one data set over other;
DATA BOLT_CORASE;
	infile 'c:/datasets/bolts-coarse.txt' firstobs=2;
	input cat_no $ size diam length price;

DATA BOLT_FINE;
	infile 'c:/datasets/bolts-fine.txt' firstobs=2;
	input cat_no $ size diam length price;

PROC PRINT data=BOLT_CORASE;
PROC PRINT data=BOLT_FINE;

DATA STACKING_EG;
	set BOLT_CORASE BOLT_FINE; * set operator with dataset names are mainly used to merge two datasets;

DATA INTERLEAVE_EG;
	set BOLT_CORASE BOLT_FINE; 
		by cat_no; * by operator is mainly used to merge two datasets interleaving;


PROC PRINT data=STACKING_EG;
PROC PRINT data=INTERLEAVE_EG;

RUN;
QUIT;

