		/*The DATA step executes and creates an output data set
		The PROC PRINT step executes and produces a report
		The PROC MEANS step is commented out, and therefore does not execute.*/
data work.newsalesemps;
   length First_Name $ 12 Last_Name $ 18 
          Job_Title $ 25;
   infile "&path/newemps.csv" dlm=',';   
   input First_Name $ Last_Name $  
         Job_Title $ Salary /*numeric*/;
run;


proc print data=work.newsalesemps;
run;
/*
proc means data=work.newsalesemps;
   var Salary;
run;*/

/*the 2 in the length clause indicated how many character can follow*/
data work.newcountry;
   length Country_Code $ 2 Country_Name $ 48;
   infile "&path/country.dat" dlm='!'; 
   input Country_Code $ Country_Name $;
run;

proc print data=work.newcountry;
run;