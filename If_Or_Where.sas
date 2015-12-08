		/*Summary of Key Differences between WHERE and IF Conditions to Subset Data Sets
			Subset Data set 									WHERE 			IF
		(No Difference between WHERE and IF Conditions)
		Using variables in data set  									X 			X
		Using SET, MERGE or--- 
		UPDATE statement if within the DATA step* 							X 			X
						(Must use IF Condition for the following)
		Accessing raw data file using INPUT statement  										X
		Using automatic variables such as _N_, FIRST.BY, LAST.BY  								X
		Using newly created variables in data set  										X
		In combination with data set options such as 
		OBS =**, POINT = , FIRSTOBS =												X
		To conditionally execute statement 											X
					(Must use WHERE Condition for the following)
		Using special operators*** such as LIKE or CONTAINS  						X
		Directly using any SAS Procedure  								X
		More efficiently**** 										X
		Using index, if available 									X
		When subsetting as a data set option 								X
		When subsetting using Proc SQL 									X 
*/
data work.donations;
   infile "&path/donation.dat"; 
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
   IF Qtr1=20;
run;

proc print data=work.donations;
run;
