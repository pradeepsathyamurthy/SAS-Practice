/* SAS has two main blocks
	Data Block - used to create SAS dataset that get stored in RAM/ROM based on command
	Proc Block - used to compute various procedures and provide its results
	we will discuss furhter and keep adding the notes as we progress */

* Create dataset;
DATA quiz_scores;
* variable or SAS dataset names in SAS should not have any special characters other than _ in it;

OPTION linesize=70 nodate pageno1;

* SAS is based on old language (PLI) and hence there are only two data type - Char and Integer;
* We can mention the variable name using the input command, if declaring a char type use $ to define it;
* Variable name should start with char or number, no speacial characters can be used;
* SAS is not case sensitive;
   input name $ score;

   /* There are 3 styles of SAS input
   		1. List Style
   		2. Collumn Style
   		3. formatted style
       we will see each input one by one */
   * 1. List Style input;
   * List style should start with datalines command and then series of list style data input;
   * Once the data set is listed last line need to be semicolon to terminate the data input;
   * These data get store in RAM and are temporary;
   * These data steps normally has a internal do while loop and hence can read the data without explicit itertion;

   DATALINES;
William 95
Jenna   92
Scott   89
Carla   94
;

* Procedure step which isused to analyze the dataset that we created in SAS;
* You need to stay aware of various procedures defined by SAS, these are keywords and must be spelled correctly;

* It is always better to print few records of the dataset to make sure everything looks good before any analysis;
* Proc print will print the last SAS dataset defined in the program;
PROC PRINT;

* Proc Contents is used to obtan detailed info about a SAS data set;
PROC CONTENTS;

PROC MEANS;

* If in case you need only a specific variable from data listed as part of proc it should be explicitly mentioned;
* Even these are SAS defined variables and need to be spelled right mostly with no space;
PROC MEANS mean minimum stddev;

* Run comman is the termination of a program for SAS to RUN a SAS program;
RUN;

* Quit will generally flush out all process related to this program from RAM;
QUIT;
