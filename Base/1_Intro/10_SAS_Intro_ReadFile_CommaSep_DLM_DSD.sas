/* Reading a Comma seperated file - use dlm and dsd */


DATA COMMA_SEP;
	* To read a delimitted file we can make use of DLM and DSD in infile command;
	* DLM= De-limiter;
	* DSD = Delimiter Sensitive Data;
	infile "c:/datasets/top-songs.txt" firstobs=3 truncover dlm=',' dsd;
	input number group $ title $ writer1 $ writer2 $ producer1 $ producer2 $ release_date DATEDTDTE8. $ record_co $ weeks top_rank;
	length group $ 18 title $ 25 writer1 $ 14 writer2 $ 14 producer1 $ 14 producer2 $ 14;
	

PROC PRINT;
RUN;
QUIT;

