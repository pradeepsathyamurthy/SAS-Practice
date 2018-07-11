/* Ch-12: Storing Macro Program */

* 1. Way-1: Understanding Session compiled Macros;
* These are temporary macros, which are created and destroyed in a single SAS session;
* These macros are stored in SAS Catelog with name work.sasmacr.<macro_name>.macro by default;
* This is a temporary SAS catelog and macro that resides here are called session compiled macros;
%MACRO macro1;
	PROC PRINT DATA=&syslast (obs=5);
	RUN;
%MEND macro1;
* below PORC SORT is to create a last accessed DATA file in SAS;
PROC SORT DATA=SASUSER.courses;
	by days;
RUN;
* executing the macros;
%macro1
* This macro macro1 is a temporary session compiled macro, it exist only till this current SAS session;
* Once this SAS session is closed this macro and the temporary catelog where it is stored is also destroyed;

* 2. Way-2: Storing Macro definitions in External files;
* This is one way to store the macro program permanently;
* Macros are stored in an external file, same can be used using %INCLUDE statement;
* Macro is compiled when the %INCLUDE statement is submitted;
* Once compiled they are available in the temporary catelog and hence can be called anytime later;
/* General form is: %INCLUDE <file_specification> </SOURCE2>; */
* file specification = physical location of macro file stored with .sas extension;
* SOURCE2 is optional, it helps to disply the source code of Macro in SAS log;
%INCLUDE 'D:\Courses\SAS\SAS-Practice\Advance\prtlast.sas' /source2;
%macro2

* 3. Way-3: Storing Macro Definitions in Catalog Source Entries;
* It is another way of permanently storing the macros;
* It is about storing a macro definition in a SOURCE entry in a SAS Catelog;
* Must store each macro program in a seperate SOURCE entry;
* Give each SOURCE entry the same name as the macro program;
* SAS catelogs are member of SAS data libraries;
* Use File > Save as Object to store macro definition as a SOURCE entry in SAS catelog;
* For e.g. I first created a SAS Catelog named MYMACS;
* Later I created MACRO1.SOURCE file in MYMACS catelog;
* This will create you a file named SASUSER.MYMACS.MACRO3.SOURCE, this is called as my catelog source entry;
* So the format is libref.catalog.entry.source;
* When the SOURCE entry is called MACRO gets compiled, if any changes done to macro, then it needs to be recompiled to get the change reflected;

* 3.1. CATALOG Procedure - can be used to check the catalog contents;
* CATALOG procedure is used to access a particular SAS source entry;
* CAT is an alias to CATALOG object;
* here we are tring to check the content present in a CATALOG;
PROC CATALOG CAT=sasuser.mymacs;
	contents;
quit;
* Above result display the source entry present in a particular catalog;

* 3.2. CATALOG access method;
* below SAS program shows how to access a SOURCE entry in a catalog;
* FILENAME <fileref> CATALOG <catalog entry> statement is used in conjection with %INCLUDE to insert macro definition into a SAS program;
* Remember FILENAME is not a macro keyword;
FILENAME prady CATALOG 'SASUSER.MYMACS.MACRO3.SOURCE';
%INCLUDE prady;
%macro3

* 3.3. Accessing multiple SOURCE entry stored inside a same catalog;
* FILENAME <fileref> CATALOG <libref.catalog>;
* %INCLUDE <fileref> (entry1);
* %INCLUDE <fileref> (entry2);
FILENAME prady CATALOG 'SASUSER.MYMACS';
%INCLUDE prady(MACRO1);
%INCLUDE prady(MACRO3) /SOURCE2;
%macro1
%macro3

* 4. Way-4: Storing Macro using AutoCall Facility;
* Can make macro accessable to current SAS session using AUTOCALL facility;
* AUTOCALL facility search for predefined source libraries for macro definition;
* As the name implies, it is the call dont automtically to access the necessary libraries which are predefined;
* this predefined source libraries are called AUTOCALL LIBRARIES;
* MACROS can be stored permanently in AUTOCALL library;
* NO need to compile the macro to make it available for execution;
* When a macro is stored in a autocall library, then:
	1. The Macro processor search the autocall library for Macro
	2. Macro Is compiled and stored as it is when it was submitted (compiled macro is stored in work.sasmacr)
	3. Macro is executed;
* Once compiled it stays for the whole session of SAS, when session ends macro is deleted from work.sasmacr catalog;
* But source code in autocall library stays in tact;
* Autocall library can be a:
	1. Directory that contain a source files
	2. Partitioned Data Set (PDS)
	3. SAS Catalog
	Method of creating a SAS autocall library totally depends on the Operating System;
* To store the source file in a directory use:
	FILE > Save AS > Create a new directory > save file as .sas file;
* Can also use FILE command FILE '<path>/Externalfilename' in commandline if needed;
* SAS also provide several macros in default autocall library like :
	%lowcase(args)
	%qlowcase(args)
	%left(args)
	%trim(args)
	%cmprs(args)
	%datatyp(args)
	These are not just a function as it looks like, these are internally the Macros which are available to user as part of defaul autocall library;

* 4.1. Accessing the Autocall Macros;
* Autocall library is either a:
	SAS Catalog or
	External Directory or
	Partitioned Data set
* This is true for all autocall library SAS supplied and for user created ones;
* All the default macros source code can be seen, for this 2 SAS system options need to be used;
* MAUTOSOURCE + SASAUTOS, SASAUTOS is used to identify the location of autocall library;
* MAUTOSOURCE = Default, specify that the autocall facility is available;
* SASAUTOS = used to identify the location of autocall library;
* MAUTOLOCDISPLAY | NOMAUTOLOCDISPLAY, in this NOMAUTOLOCDISPLAY is the default;
* MAUTOLOCDISPLAY is a boolean option, it will display the Note in sas log saying the path from which the autocall library was derived;
* Good coding practice is to create any new user defined macros also into sasautos instead os creating one as all SAS default macros are stored here only;
* These are SAS system OPTIONS;
OPTIONS mautosource SASAUTOS=(sasautos,'C:\Users\prade\Documents\My SAS Files\9.4','D:\Courses\SAS\SAS-Practice\Advance\sas_autocall_dir');
OPTIONS MAUTOLOCDISPLAY;
* Steps how SAS treats the Macro when autocall library is set:
	1. Searches the autocall library
	2. Bring in the Source to current SAS session
	3. Issue an error message if source is not found
	4. Submits all statements and get them compiled
	5. Stores the compiled macros in a temporary SAS catalog work.sasmacr
	6. Call the macro;
* If the macro is available for current session already,then only the session compiled macro is referred and not the one in autocall library;
* If you see, once we add our user created directory to SAS Autocall library using OPTIONS, by just executing the macro we get the desired results;
%macro4

* 5. Way-5: Using Stored Compiled Macros;
* When a macro is compiled, it is stored in the temporary SAS catalog work.sasmacr by default;
* Can also store compiled macro in a permanent SAS catalog;
* Advantages of using stored compiled macros:
	1. No need to compile when macro call is made
	2. session compiled macro and autocall facilityare also available in the same session
	3. Users cannot modify compiled macros;
* MSTORED and SASMSTORE are SAS options that affects stored compiled macros;
* MSTORED = controls whether the stored compiled macro facility is availble;
* SASMSTORE = controls where the macro facility looks for stored compiled macro;
* NOMSTORED is the default, does not search for stored compiiled macro;
libname prady1 'D:\Courses\SAS\SAS-Practice\Advance\stored_compiled_macro';
OPTIONS MSTORED SASMSTORE=prady1;

* 5.1. Creating Stored Compiled Macros;
* To create a permanently stored compiled macro, you must:
	1. assign a libref (this is the library under which compiled macros will get saved)
	2. set OPTIONS MSTORED and SASMSTORE=<libref>
	3. use the STORE keyword in the %MACRO when you submit the macro definition;
* Some of the restrictions on stored compiled macros:
	1. SASMACR is the only catalog in which compiled macro can be stored
	2. Cannot copy stored compiled macros across operating systems
	3. Source cannot be re-created from compiled macros;

* 5.2. USING the SOURCE options;
* %MACRO + /STORE +SOURCE = used to combine and store the source of the compiled macro with compiled macro code;
* %MACRO <macro_name> /STORE SOURCE is the way to define it;
* Suppose if we need below macro named macro5 in compiled form in a SAS library;
libname prady1 'D:\Courses\SAS\SAS-Practice\Advance\stored_compiled_macro';
OPTIONS MSTORED SASMSTORE=prady1;
%MACRO macro5 /store source;
	PROC PRINT DATA=&syslast (obs=5);
	RUN;
%MEND macro5;
* When I created above folder mentioned in libref, the folder was empty;
* On executing the above code, since there was no Sasmacr in my libref, Sasmacr catalog gets created;
* Inside this Sasmacr catalog we can find the macro named Macro5 in the compiled state;
* Same can be verified using the PROC CATALOG method;
PROC CATALOG cat=prady1.Sasmacr;
	contents;
RUN;
QUIT;

* 5.3. Accessing stored compiled Macro;
* To access a stored compiled macro do the following:
	1. Define a libref where the compiled macro is stored
	2. Set MSTORED and SASMSTORE=libref in SAS OPTIONS	
	3. call the macro;
* Only one permanent catalog containing compiled macros can be accessed at any given time;
libname prady1 'D:\Courses\SAS\SAS-Practice\Advance\stored_compiled_macro';
OPTIONS MSTORED SASMSTORE=prady1;
%macro5

* 5.4. Accessing Stored Macro Code - %COPY;
* This option is available only when a macro is created using the SOURCE option in place;
* In such case, %COPY option is used to access the stored source code;
%COPY macro5/source;
* We can see the source code of macro5 being printed in SAS log;
* This kind of stored compiled macros can be used alogn with session compiled macros and autocall facility;
* when we try to call a macro using %<macro_name> the macro processor searches for macro words as:
	1. <macro_name>.macro in the temporary work.Sasmacr catalog
	2. If not found in default SAS catalog, it will seach in libref.Sasmacr catalog. In this case MSTORE and SASMSTORED=libref should be defined
	3. If not found in above, seach will be done in <macro_name> autocall library, in this case MAUTOSOURCE and SASAUTOS must be specified
	4. If not even found in the above, SAS will through warning accordingly;
