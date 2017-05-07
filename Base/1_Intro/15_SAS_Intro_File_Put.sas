/*put =  Writing SAS Data set to ROM instead of RAM, 
before using the put command we need to create the file usning file command */

* Use _null_ so that the SAS dataset created will not be stored in the RAM memory;
* _null_ is a SAS defined name, which tell the system not to store the dataset in RAM;
data _null_;
   infile 'c:/datasets/kids.txt' firstobs=2;
   * file command is used to create a file in the ROM in the path specified;
   * file command can be used only with the _null_ data;
   file 'c:/datasets/kids-out.txt';
   input name $ gender $ age;
   * using put command we can write the SAS data created into the ROM; 
   * thus, put command is used to write the data into disc;
   * put is always a part of data block;
   put 'name=' name 'gender=' gender 'age=' age;

run;
quit;
