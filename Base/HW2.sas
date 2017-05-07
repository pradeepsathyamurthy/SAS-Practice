/****************************************************************************************************************
Author: Pradeep Sathyamurthy
Date: 27-April-2017
Course: CSC-433
Guiding Prof: Prof. Steve Jost
Project: Project-3
Dataset Name: erie-marathon-2006.txt
Variable of Interest for Project-3: Name, Jersey Number, Gender, Age, Home Town, Final Time
Topics Covered in project-1&3: 
Data and Proc steps, title, label infile, input, scan, informat, options, format, put, files, header, subsetting if
keep, drop, cross validation
******************************************************************************************************************/

/*
1. Produce these reports:
						1. All runners (no percentages)
						2. All male runners
						3. All female runners

2. Each report should list:
						1. The number of runners on that report
						2. The average time for the runners on that report
						3. The percent of total runners.  

3. Show these variables on each report:
 
						Name, Jersey Number, Gender, Age, Home Town(city), Final Time.
*/

* Using the pagesize to custom the output window, so that data gets properly written during external file write;
options linesize=80 pagesize=450 nodate nonumber;

/************************************************************************
Reading the dataset and keeping the desired variables as requested
Name, Jersey Number, Gender, Age, Home Town(city), Final Time.
************************************************************************/
DATA MARATHON;
	infile "C:\datasets\erie-marathon-2006.txt" firstobs=12 dlm=',' dsd truncover;
	input id $ 5. place 6. @18 finisher $46. @87 final_time TIME8. @98 mile_pace $5.;
	title 'Marathon Dataset';
	if id = . then delete;
	name = scan(finisher, 1, ",");
    age_gender = scan(finisher, 2, ",");
    city = scan(finisher, 3, ",");
	state = scan(finisher,4,",");
	label id='Jersey Number' 
		  place='Rank in Marathon' 
		  name='Name of the player' 
		  final_time='Final time taken to Finish Marathon'
		  city='Home Town' 
		  mile_pace='Pace';
	
	* Till above we have experimented as part of Project-1;
	* Coding implementation for Project-2 requirements actually starts here logically;
	* seperating the gender from the age variable;
	if find(age_gender,'*') then gender='Female';
	else gender='Male';
	drop finisher place;
	keep name id gender age_gender city state final_time; * <-- Having only the variables requested as part of Project-3;


/************************************************************************
Report -1
All runners (no percentages)
output file name will be: 'marathon_all_runners.txt'
************************************************************************/
PROC SORT DATA=MARATHON;
	by gender;

/*PROC PRINT DATA=MARATHON;
	format final_time TIME8.;
	var name id gender age_gender city final_time;*/
	
PROC MEANS DATA=MARATHON noprint;
	output out=MARATHON_ALL n=tot_runners mean=avg_time;

DATA _null_;
	file 'c:/datasets/marathon_all_runners.txt' print header=head;
	title "Report of all Runners participated in marathon";
	if _n_=1 then set MARATHON_ALL; * Trying to keep the result obtained from MARATHON_ALL dataset throughout;
	set MARATHON;	
    put name @25 id @35 gender @45 age_gender @50 city @70 final_time time8.;
	return;
	head:
	put /;
	put 'Total Number of Runners in Marathon:' tot_runners;
	put 'Average time taken by runner:' avg_time TIME8.; *<-- Formatting the Average Final Time for Report;
	put /;
	put 'Name' @25 'Jercy_ID' @35 'Gender' @45 'Age' @50'HomeTown' @70 'Final_Time';


/************************************************************************
Report -2
All male runners
output file name will be: 'marathon_male_runners.txt'
************************************************************************/

DATA MARATHON_MALE_DATA;
	set MARATHON;
		where gender='Male';	*<-- Filterring out only the Male Data;

PROC MEANS DATA=MARATHON_MALE_DATA noprint;
	output out=MARATHON_MALE n=tot_runners_male mean=avg_time_male; *<-- Computing the average run time of Male only runners;

DATA _null_;
	file 'c:/datasets/marathon_male_runners.txt' print header=head;
	title "Report of Male Runners participated in marathon";
	if _n_=1 then set MARATHON_ALL; *<-- Need this to get the total runner in marathon;
	if _n_=1 then set MARATHON_MALE; * <-- Need this to get the count of male runners in marathon;
	set MARATHON_MALE_DATA; *<-- Need this to get it printed in the report;
	male_percent=(tot_runners_male/tot_runners)*100; *<-- calculating the percentage of Male runners, PERCENT format is not available so multiplying with 100;
	put name @25 id @35 gender @45 age_gender @50 city @70 final_time time8.;
	return;
	head:
	put /;
	put 'Total Number of Male Runners in Marathon:' tot_runners_male;
	put 'Average time taken by Male runner:' avg_time_male TIME8.;
	put 'Percentage of Male runners in Marathon:' male_percent '%';
	put /;
	put 'Name' @25 'Jercy_ID' @35 'Gender' @45 'Age' @50'HomeTown' @70 'Final_Time';


*PROC PRINT DATA=MARATHON_MALE_DATA;
*PROC PRINT DATA=MARATHON_MALE;


/************************************************************************
Report -3
All female runners
output file name will be: 'marathon_female_runners.txt'
************************************************************************/
DATA MARATHON_FEMALE_DATA;
	set MARATHON;
		where gender='Female'; *<-- Filterring out only the Female Data;

PROC MEANS DATA=MARATHON_FEMALE_DATA noprint;
	output out=MARATHON_FEMALE n=tot_runners_female mean=avg_time_female; *<-- Computing the average run time of Female only runners;

DATA _null_;
	file 'c:/datasets/marathon_female_runners.txt' print header=head;
	title "Report of Female Runners participated in marathon";
	if _n_=1 then set MARATHON_ALL; *<-- Need this to get the total runner in marathon;
	if _n_=1 then set MARATHON_FEMALE; * <-- Need this to get the count of Female runners in marathon;
	set MARATHON_FEMALE_DATA; *<-- Need this to get it printed in the report;
	female_age=substr(age_gender,1,3);
	female_percent=(tot_runners_female/tot_runners)*100;
	put name @25 id @35 gender @45 female_age @50 city @70 final_time time8.;
	return;
	head:
	put /;
	put 'Total Number of Feale Runners in Marathon:' tot_runners_female;
	put 'Average time taken by Female runner:' avg_time_female TIME8.;
	put 'Percentage of Female runners in Marathon:' female_percent '%';
	put /;
	put 'Name' @25 'Jercy_ID' @35 'Gender' @45 'Age' @50'HomeTown' @70 'Final_Time';


*PROC PRINT DATA=MARATHON_FEMALE_DATA;
*PROC PRINT DATA=MARATHON_FEMALE;

RUN;
QUIT;
