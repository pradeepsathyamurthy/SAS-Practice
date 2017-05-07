/* Interleaving two datasets - use 'in' with 'by' operator along with set*/
* Here we are trying to merge each row of one data set over other;
DATA BOLT_CORASE;
	infile 'c:/datasets/bolts-coarse.txt' firstobs=2;
	input cat_no $ size diam length price;

DATA BOLT_FINE;
	infile 'c:/datasets/bolts-fine.txt' firstobs=2;
	input cat_no $ size diam length price;

*PROC PRINT data=BOLT_CORASE;
*PROC PRINT data=BOLT_FINE;

DATA INTERLEAVE_EG;
	set BOLT_CORASE (in=BOLT_CORASE) BOLT_FINE (in=BOLT_FINE); *in operator is mainly used to merge two datasets;
		by cat_no; * by operator defines the common column based on which this interleave join must take place ;
   	
DATA STACKING_EG_WITH_TYPE;
	set BOLT_CORASE (in=BOLT_CORASE) BOLT_FINE (in=BOLT_FINE);
		by cat_no; *Data set will be sorted here based on CAT_NO and then interleaving of data happens;
	if BOLT_CORASE then type='BOLT_CORASE';
   	if BOLT_FINE then type='BOLT_FINE';

PROC PRINT data=STACKING_EG;
PROC PRINT data=STACKING_EG_WITH_TYPE;

RUN;
QUIT;

