/* Chapter -14 */
/* Combining Data Vertically Using the DATA Steps */
* There are two way in which we can concatinate two datasets vertically:
	1. Using FILENAME, INFILE - FILEREF
	2. Using PROC APPEND;

/* 1. Combining vertically using FILENAME statement */
* This is one of the basic bethod to concatenate files vertically;
* You can use single FILEREF to associate multiple raw data files, thus FILEREF can deal with one or many Raw data file;
* Multiple files in FILEREF is enclosed in a paranthesis ();
* Remember FILEREF is a variable that needs to be declared and not a actual SAS key word;
FILENAME qtr1('D:\Courses\SAS\SAS-Practice\Advance\month1.dat' 'D:\Courses\SAS\SAS-Practice\Advance\month2.dat' 'D:\Courses\SAS\SAS-Practice\Advance\month3.dat');
* Use PROC FSLIST procedure to look at the Data file structure and content;
PROC FSLIST FILEREF=qtr1;
RUN;
QUIT;
/* 1.1. Using FILEREF variable in infile */
* Generally we have seen infile is used to read only a single file so far and hard code the file path;
* However, we can also use fileref name in the INFILE to read the raw data from the physical loation one after the other;
* look for the use of : in the base cert;
DATA work.firstqtr;
	infile qtr1;
	input Flight $ Origin $ Dest $ Date : date9. RevCargo : Comma15.2;
RUN;
QUIT;
* let us print this concatenated dataset;
PROC PRINT DATA=work.firstqtr;
RUN;
PROC PRINT DATA=work.firstqtr;
	format date date9. revcargo dollar11.2;
RUN;

/* 2. Combining vertically using INFILE and FILEVAR statement */
* file Specification given in INFILE is a place holder, it is neither a physical file name location not fileref;
* temp = Arbitrarily named placeholder, it is neither a physical file path nor a fileref;
* nextfile = Varible name given to FILEVAR, which contain the name of the Raw datafile to be read;
* Multiple INFILE can also be usedm this program is for practicing INFILE with FILEVAR; 
DATA work.quarter;
	do i=1,2,3;
		* PUT(i,2.) here 2. is used to reserve 2 space followed by month, if datafile name is month12, month13, then after month we need 2 space;
		* Since, our data is month1, month2, month3 this 2. is not necessary in PUT, still we will use to see the functionality of COMPRESS;
		* COMPRESS() is used to trim any string that is passed to it, by default compress space;
		* COMPRESS() can be combined with assignment statement as below to improve its efficiency;
		* || or !! can be used as concatenation operator;
		nextfile="D:\Courses\SAS\SAS-Practice\Advance\month"||COMPRESS(PUT(i,2.),' ')||".dat";
		INFILE temp FILEVAR=nextfile;
		input Flight $ Origin $ Dest $ Date : date9. RevCargo : Comma15.2;
		* Now we need OUTPUT to push these records to Quarter dataset;
		OUTPUT;
	end;
	* STOP is needed to avoid any infinite loop that might possibly occur due to DO loop;
	stop;
RUN;
* 2.1 Using END= operator to make program more dynamic;
* make sure your data file has no blank line in the end;
DATA work.quarter;
	do i = 1, 2, 3;
		nextfile="D:\Courses\SAS\SAS-Practice\Advance\month"||COMPRESS(PUT(i,2.)||".dat",' ');
		* END= is used to read through untill the last record;
		* So, in such case END= is very important;
		do until(lastobs);
			* END=<var_name>, this <var_name> is defined by user but controlled by SAS;
			* <var_num> is assigned either 0 or 1;
			* 0 implies not the last record, 1 implies last record;
			* END= is like a automatic variable it will not be displayed in dataset;
			INFILE temp FILEVAR=nextfile END=lastobs;
			input Flight $ Origin $ Dest $ Date : date9. RevCargo : Comma15.2;
			* Now we need OUTPUT to push these records to Quarter dataset;
			OUTPUT;
		end;
	end;
	* STOP is needed to avoid any infinite loop that might possibly occur due to DO loop;
	stop;
RUN;
QUIT;
* lets print the dataset with modified label;
PROC PRINT DATA=work.quarter label;
	label i = 'Month';
	format date date9. revcargo dollar11.2;
RUN;
QUIT;
* 2.3. Using Date function and INTNX to make the program much more dynamic;
* MONTH() and TODAY() function is used to derive the current system date and Month as integer respectively;
DATA work.quarter1;
	monthnum=month(today());
	currmon=monthnum-3;
	midmon=currmon-1;
	lastmon=midmon-1;
	do i=lastmon,midmon,currmon;
		nextfile="D:\Courses\SAS\SAS-Practice\Advance\month"||COMPRESS(PUT(i,2.)||".dat",' ');
		do until(lastobs);
			INFILE temp FILEVAR=nextfile END=lastobs;
			input Flight $ Origin $ Dest $ Date : date9. RevCargo : Comma15.2;
			OUTPUT;
		end;
	end;
	stop;
RUN;
QUIT;
* lets print the dataset with modified label;
PROC PRINT DATA=work.quarter1 label;
	label i = 'Month';
	format date date9. revcargo dollar11.2;
RUN;
QUIT;
* 2.4. INTNX() function is used to increment a date, time or datetime value by a given interval or intervals and return a date, time and datetime;
DATA work.quarter2 (drop=monthnum currmon midmon lastmon) ;
	monthnum=month(today());
	currmon=month(intnx('month',today(),-3));
	midmon=month(intnx('month',today(),-4));
	lastmon=month(intnx('month',today(),-5));
	do i=lastmon,midmon,currmon;
		nextfile="D:\Courses\SAS\SAS-Practice\Advance\month"||COMPRESS(PUT(i,2.)||".dat",' ');
		do until(lastobs);
			INFILE temp FILEVAR=nextfile END=lastobs;
			input Flight $ Origin $ Dest $ Date : date9. RevCargo : Comma15.2;
			OUTPUT;
		end;
	end;
	stop;
RUN;
QUIT;
* lets print the dataset with modified label;
PROC PRINT DATA=work.quarter2 label;
	label i = 'Month';
	format date date9. revcargo dollar11.2;
RUN;
QUIT;

/* 3. Combining vertically using PROC APPEND */
* PROC APPEND is used concatenate two SAS dataset;
* BASE=<Dataset> is the fundamental dataset to which data is concatenated;
* Always the table structure of the BASE dataset is carried forward with or without FORCE function in place;
* SAS reads Dataset mentioned in the DATA= part and not BASE= part, thus improve efficiency;
* If collumns in BASE dataset is more than DATA dataset, missing values are intriduced to columns appended for those rows from DATA;
* If Columns in BASE is more, SAS will allow the concatenation as it is;
* However, it is not the case when columns in DATA is more than BASE, in such case FORCE function needs to be used with PROC APPEND;
PROC PRINT DATA=One;
RUN;
PROC PRINT DATA=two;
RUN;
PROC APPEND
	BASE=work.One
	DATA=work.two;
RUN;
QUIT;
PROC PRINT DATA=One;
RUN;
PROC PRINT DATA=two;
RUN;
* Since there is a mismatch between dataset columns PROC APPEND will through error, FORCE needs to be used;

/* 4. Using FORCE in PORC APPEND */
* FORCE will through warning but it will append tables by dropping/tuncating the extra cols in DATA dataset;
* Data structure of BASE dataset is the final and ultimate;
* Dropping of cols from DATA dataset happens when cols in DATA is more than cols in BASE;
* Truncating happens in DATA dataset when length of cols is greater than length of cols in BASE;
* When the data type is different, Data Type from BASE= dataset is maintained and missing values is assigned to DATA= whose column datatype is unmatched;
PROC APPEND
	BASE=work.One
	DATA=work.two FORCE;
RUN;
QUIT;
* lets printout;
PROC PRINT DATA=One;
RUN;
PROC PRINT DATA=two;
RUN;
/* 5. Storing Raw datafile name in SAS Dataset */
DATA RAWDATA;
input readit $ char15.;
datalines;
month1.dat
month2.dat
month3.dat
;
RUN;
PROC PRINT DATA=RAWDATA;
RUN;
QUIT;
* Now let us see how to read these datafile names stored in SAS dataset to access it;
LIBNAME lib 'D:\Courses\SAS\SAS-Practice\Advance';
DATA work.newroute;
	set work.rawdata;
	* FILEVAR variable must be the column name which stores the table name in it;
	* Look at the usgae of IN here before filevar;
	infile in filevar = readit END=lastfile;
	do while(lastfile=0);
		input Flight $ Origin $ Dest $ Date : date9. RevCargo : Comma15.2;
		OUTPUT;
	end;
RUN;
QUIT;

/* 6. Storing Raw datafile name in External File */
LIBNAME lib 'D:\Courses\SAS\SAS-Practice\Advance';
DATA work.newroute;
	infile lib('rawdatafiles.dat');
	input readit $10.;
	infile in filevar = readit END=lastfile;
	do while(lastfile=0);
		input Flight $ Origin $ Dest $ Date : date9. RevCargo : Comma15.2;
		OUTPUT;
	end;
RUN;
QUIT;
