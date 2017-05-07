/* Reading single observation spread across multiple rows  */

DATA data_multi_col;
	infile "C:\datasets\quiz3.txt";
	
	* When a single observation is spread across multiple rows then we cannot use collumn type input definition;
	* In this case we need to define the length of each variable and then use # or / to skip through the lines;
	* #2 says always skip line2 after reading first variable as a new observation;
	* or just use / which is used to mention the same as skip next line;

	length name $ 10;
	input name $ 
		#2 (q1-q5) (1.) 
		#3  mid final;

	/*length name $ 10;
	input name $ 
		/ (q1-q5) (1.) 
		/  mid final; */
	if mid=. then mid=0;
	if final=. then final=0;
	quiz_score=mean(q1,q2,q3,q4,q5);
	total_score=quiz_score*8 + mid*0.3 + final*0.3;
	* For both assigning and equal to operator it is just one = and not ==;
	if total_score>=90 then grade='A';
	else if total_score>=80 then grade='B';
	else if total_score>=70 then grade='C';
	else if total_score>=60 then grade='D';
	else grade='F';
	keep name total_score grade;

PROC PRINT;
RUN;
QUIT;
