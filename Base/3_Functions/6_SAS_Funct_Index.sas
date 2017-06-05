/* This will cover the functions available in SAS and its usgae */
* index - Searches a character expression for a string of characters, and returns the position of the string's first character for the first occurrence of the string;
DATA INDEX_DATA;
	a = 'ABC.DEF(X=Y)';
   	b = 'X=Y';
	c = 'ABC.DEF(x=Y)';
   	x = index(a,b);
	y = index(a,c);

PROC PRINT DATA=INDEX_DATA;
	var a b c x y;

RUN;
QUIT;
