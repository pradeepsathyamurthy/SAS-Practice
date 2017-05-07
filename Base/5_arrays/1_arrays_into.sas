/* Arrays in SAS */

* 1. Arrays in SAS will not create any new space;
* 2. They are not considred as a rigid variable to SAS but just a pointer name of a place holder;
* 3. This is the reason why arrays done get printed in SAS on PROC Print of a dataset that uses arrays;
* 4. Genrally used along with do or do untill or do while loops to iterate an operation in SAS;
* 5. [] or {} is used to define an array, we can also use () to define array size;
* 6. Sample array declaration array exam (7) q1 q2 q3 q4 q5 midterm final;
* 7. Here, exam is a pointer to a place holder which has varibales q1 to q5, midterm and finals;

* Treating missing values using array ;
DATA ARRAY_EG;
	infile 'C:\datasets\quiz1.txt' firstobs=3;
	input name $ @11 (q1-q5) (1.) midterm finals;
	array exam(7) q1 q2 q3 q4 q5 midterm finals; * This will create a pointer to the place holder;
	*array exams(7) q1-q5 midterm final; * <-- even this can be used, do not use () for q1-q5;
	do i=1 to 7;
		if exam(i)=. then exam(i)=0;
	end;
	drop i;
PROC PRINT DATA=ARRAY_EG;

RUN;
QUIT;

