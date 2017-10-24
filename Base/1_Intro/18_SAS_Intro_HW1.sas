/****************************************************************************************************************
Author: Pradeep Sathyamurthy
Date: 13-April-2017
Course: CSC-433
Guiding Prof: Prof. Steve Jost
Project: Project-1
Dataset Name: erie-marathon-2006.txt
Variable of Interest for Project-1: ID, Place, Finisher, Final Time, Pace
Topics Covered in project 1: 
Data and Proc steps, title, label infile, input, scan, informat, options, format, put, files, header, subsetting if
******************************************************************************************************************/

/***************************************** 
Question Number-1,2,3 covered below
*****************************************/
* Using the pagesize to custom the output window, so that data gets properly written during external file write;
options linesize=80 pagesize=450 nodate nonumber;

DATA MARATHON;
	infile "C:\datasets\erie-marathon-2006.txt" firstobs=12 dlm=',' dsd truncover;
	* we are asked to select ID Number, Place, First 10 to 13 Characters of the Name, Final Time, Mile Pace from dataset ;
	input id 5. place 6. @18 finisher $46. @87 final_time TIME8. @98 mile_pace $5.;
	if id = . then delete;
	*if id ~= .;  * Subsetting if, this can be used as another method to delete missing rows;
	* Since finisher has consolodate details in a comma seperated format, used scan method to read one data at a time;
	name = scan(finisher, 1, ",");
    age = scan(finisher, 2, ",");
    city = scan(finisher, 3, ",");
	state = scan(finisher,4,",");
	* labels are used to descrive the columns defined as part of input statement;
	label id='ID' 
		  place='Rank in Marathon' 
		  name='Name of the player' 
		  final_time='Final time taken to Finish Marathon' 
		  mile_pace='Pace';
* Printing the dataset with requested column as part of HW-1;
PROC PRINT;
	format final_time TIME8.;
	title "Dataset 'erie-marathon-2016.txt' with requested columns";
	var id place name final_time mile_pace;

PROC PRINT LABEL;

/**************************************** 
Question number 4.1 covered below 
*****************************************/
* Sorting the data set by name;
PROC SORT;
	by name;
PROC PRINT;
	format final_time TIME8.;
	title "Dataset sorted by name";
	var id place name final_time mile_pace;

/**************************************** 
Question number 4.2 covered below 
*****************************************/
* Sorting the dataset by final_time;
PROC SORT;
	by final_time;
PROC PRINT;
	format final_time TIME8.;
	title "Dataset sorted by time";
	var id place name final_time mile_pace;
* Writing to an external output file names marathon_out.txt;
data _null_;
	file 'c:/datasets/marathon_out.txt' print header=head dropover;
	title "Data set erie-marathon-2016 sorted by time with necessary variables";
	set MARATHON end=eof;
		by final_time;
	if first.final_time=1 or first.final_time=0 then do;
      put @10 id @15 place @25 name @50 final_time TIME8. @65 mile_pace;
    end;
	return;
	head:
	put /;
	put @10 'id' @15 'place' @25 'name' @50 'final_time' @65 'mile_pace';

RUN;
QUIT;
