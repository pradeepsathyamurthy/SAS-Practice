/* Stacking or merging two datasets - use in operator along with set
	e.g. set dataset_name1 dataset_name2; */
* Here we are trying to merge one data set over other;
DATA BOLT_CORASE;
	infile 'c:/datasets/bolts-coarse.txt' firstobs=2;
	input cat_no $ size diam length price;

DATA BOLT_FINE;
	infile 'c:/datasets/bolts-fine.txt' firstobs=2;
	input cat_no $ size diam length price;

*PROC PRINT data=BOLT_CORASE;
*PROC PRINT data=BOLT_FINE;

DATA STACKING_EG;
	set BOLT_CORASE BOLT_FINE;
   	
DATA STACKING_EG_WITH_TYPE;
	set BOLT_CORASE (in=BOLT_CORASE) BOLT_FINE (in=BOLT_FINE); * in carries 0 or 1, it just say if it is in particular dataset or not;
	if BOLT_CORASE then type='BOLT_CORASE';
   	if BOLT_FINE then type='BOLT_FINE';

PROC PRINT data=STACKING_EG;
PROC PRINT data=STACKING_EG_WITH_TYPE;

RUN;
QUIT;

