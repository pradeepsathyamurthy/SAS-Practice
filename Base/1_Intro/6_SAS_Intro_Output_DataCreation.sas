/* 5_SAS_Intro_Output_DataCreation.sas */

* Here we will see how to create a data set without using input statement;
* output command is used, we need to define each row using its variable name and at end give output;
* This is a tedious process and not used much;
* Normally used when you want to send an observation to the dataset in the middle of the the data step;
* If you want to keep adding data in dataset u go to use output that number of times;
* If there is only one output data defined before that only will get stored in SAS dataset;
DATA data_no_input;
name="Pradeep";
gender="Male";
age="31";
output;
name="Sruthi";
gender="Female";
age="24";
output;

PROC PRINT data=data_no_input;

RUN;
QUIT;
