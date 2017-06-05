* conversts a character to a numeric value;
data testin;
      input sale $9.;
      fmtsale=input(sale,comma9.);
      datalines;
   2,115,353
   ;
