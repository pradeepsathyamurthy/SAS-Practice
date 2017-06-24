/* Combing SAS Datasets is the focus in this chapter */
/* This to know includes:
1. One to One Reading - overwrite  of datasets - Multiple SET statement - No Missing Values - Values are skipped
2. Concatenating - Overlap of dataset one above the other - Single SET statement - Missing Values - No Values skipped
3. Interleaving - Mutiple Mathching Observation for a unique value mentioned in BY - Single SET statement - No Missing Value - No Values Skipped
4. Match Merging - One matching observation for a unique value mentioned in BY - Single MERGE statement - Missing Values - No Values skipped
How to rename a variable using RENAME?
How to create and use temporary IN variable?
How to use DROP= and KEEP= while merging datasets? */

* 1. One to One Reading - overwrite  of datasets - Multiple SET statement - No Missing Values - Values are skipped;
DATA WORK.A;
	input VarA 3. @;
	datalines;
1 2 3 4 5
;



