* Usage of array for some extensive operations;

DATA MIDTERM_DATA;
	infile 'C:\datasets\midterms.txt' firstobs=2;
	input name $25. sid yr @40 (ans1-ans20) ($1.);
	exam='mid';

DATA FINALS_DATA;
	infile 'C:\datasets\finals.txt' firstobs=2;
	input name $25. sid yr @40 (ans1-ans20) ($1.);
	exam='final';

DATA MID_KEY;
	infile 'C:\datasets\midterm-key.txt';
	input (correct_ans1-correct_ans20) ($1.);
	exam='mid';

DATA FINAL_KEY;
	infile 'C:\datasets\final-key.txt';
	input (correct_ans1-correct_ans20) ($1.);
	exam='final';

PROC SORT DATA=MIDTERM_DATA;
	by sid;

PROC SORT DATA=FINALS_DATA;
	by sid;

DATA MID_SCORE;
	merge MIDTERM_DATA MID_KEY;
		by exam;
	*retain correct_ans1-correct_ans20;
	array response(20) $ ans1-ans20;
	array key(20) $ correct_ans1-correct_ans20;
	mid_score=0;
	do i=1 to 20;
		if response(i)=key(i) then mid_score=mid_score+1;
	end;
	/*do i=1 to 20;
			mid_score=mid_score+(response(i)=key(i));
	end;*/
	stud_mid_score=mid_score;
	keep name sid stud_mid_score;
	*drop i exam mid_score ans1-ans20 correct_ans1-correct_ans20;

DATA FINAL_SCORE;
	merge FINALS_DATA FINAL_KEY;
		by exam;
	*retain correct_ans1-correct_ans20;
	array response(20) $ ans1-ans20;
	array key(20) $ correct_ans1-correct_ans20;
	final_score=0;
	do i=1 to 20;
		if response(i)=key(i) then final_score=final_score+1;
	end;
	/*do i=1 to 20;
			mid_score=mid_score+(response(i)=key(i));
	end;*/
	stud_final_score=final_score;
	keep name sid final_score;
	*drop i exam mid_score ans1-ans20 correct_ans1-correct_ans20;

*PROC PRINT data=MIDTERM_DATA;
*PROC PRINT data=FINALS_DATA;
*PROC PRINT data=MID_KEY;
*PROC PRINT data=FINAL_KEY;
PROC PRINT data=MID_SCORE;
	title "Mid Term Score";

PROC PRINT data=FINAL_SCORE;
	title "Final Term Score";

DATA GRADES;
	merge MID_SCORE FINAL_SCORE;
		by sid;
	if stud_mid_score = . then stud_mid_score = 0;
	if final_score = . then final_score = 0;
	course_score = (stud_mid_score+final_score) * 100 / 40;
	if course_score >= 90 then grade = 'A';
	else if course_score >= 80 then grade = 'B';
	else if course_score >= 70 then grade = 'C';
	else if course_score >= 60 then grade = 'D';
	else grade = 'F';

PROC PRINT data=GRADES;
	title "Students Final Grades";


RUN;
QUIT;

