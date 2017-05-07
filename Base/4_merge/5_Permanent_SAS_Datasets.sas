/* Permanent Datasets in SAS */
* Permanent datsets will store data in ROM ;
* While temporary dataset will store datsets in RAM, thus get vanished on system restart;
* Temporary dataset is names with work prefix like Work.SAMPLEDATASET, which can be found inside the active libraries left side;
* Permanent SAS datset has a two parts: Part-1: Folder/User_Library Name and Part-2: Dataset Name like First.KIDSDATA

* CreatePermDS Example
  Create permanent SAS dataset in the folder first_grade
  must exist before running this script;

options linesize=70 nodate pageno=1;
libname grade_1 'C:\datasets\Sample_SaS_Perm_Dataset'; * This will create a SAS internal library in RAM which points to ROM where dataset is placed;
data grade_1.kids; *Permanent SAS dataset definition, define using data command and call using set command;
   input name $ gender $ age;
   datalines;
Sally F 6
Alex  M 6
Jason M 6
Molly F 6
;
