* Use a macro variable for simple text substitution in a SAS script;
* First try to code the actual SAS program and then convert it into macro;
%LET m_Variety = Anthurium; * <- remember while defining a macro variable no need of "";
 
DATA FLOWER;
	infile 'C:\datasets\tropical-sales.txt';
	input CustomerID $ @6 SaleDate MMDDYY10. @17 Variety $9. Quantity;
	format SaleDate DATE9.;
	if Variety = "&m_Variety"; *<- Macro variable can be used using & sign enclosed with in "";
RUN;

PROC PRINT DATA=FLOWER;
	title "Sales of the flower &m_Variety"; *<- Reusing the macro variable again;
RUN;
QUIT;

