  	/*the var statment grabs the columns with the corresponding name
  	sum request total for the NUMERIC variable and places it at the bottom of the field*/
proc print data=orion.sales;
run;

proc print data=orion.sales;
	var first_name Last_name salary;
	*where salary >80000; /*comment out a line with '*' ending with a ';'*/
	sum salary;
run;

		/*example of improper syntax. Only the second where clase is reconized,
		it replaces the first where with the second.
		  SAS won't excute two where statments*/
		  
		  /*THE STATEMENT BELOW IS A PURPOSELY MADE ERROR!!!
		  	FIRST WHERE STATEMENT IS IGNORED*/
proc print data=orion.sales;
   where Country='AU';
   where Salary<30000;
run;

		/*proper way of running the previous proc statement*/
proc print data=orion.sales;
	where country='AU' & salary<30000;
run;

		/*this is a 'not in ('')' example*/
proc print data=orion.sales;
	where country not in ('US');
run;
		/*NOT useful at all because there are only two countries in the data set,
		but the point is 'in' can contain multiple values.*/
proc print data=orion.sales;
	where country not in ('US','AU');
run;
		/*another simple example of retrieving a single value outcome.*/
proc print data=orion.sales;
	where country not='US';
run;

proc print data=orion.sales noobs;
	where country='US';
run;

		/*following statement shows all obs that has AU as country and
		contains Rep character string.contains can also be called using the '?'
				CONTAINS means have the following string in the variable.*/
proc print data=orion.sales;
	where country='AU' and
	job_title CONTAINS 'Rep. IV';
run;

		/*between-and is an inclusive range in the where operator.
		ex. where salary between 5000 and 10000; the not operator can be added
		before between to specify all value out of range*/
proc print data=orion.sales;
	where salary between 50000 and 100000;
run;
		
		/*To complicate the between-and a similar statement is--
			where 50000<= salary<=100000;*/
proc print data=orion.sales;
	where salary not between 50000 and 100000;
run;
		/*to add more conditions to the where operator add the where same and operator.
			where same and gender='F';*/
proc print data=orion.sales;
	where salary not between 50000 and 100000;
	where same and gender='F';
run;
		/*is null and is missing displays the values with the . for numbers
		and the blank space for characters.  another why of using the is null or
		is miss is to say where salary =.;
						  where Last_Name='';
		same as 		  salary is null;
						  last_Name is missing; not can be added*/
proc print data=orion.sales;
	where salary is missing;
run; /*bad example because unfortunately everyone is getting paid!*/
						  
		/*the like operator compare character values to specify patterns.
		 % any number of characters can occupy that position
		 	ex. where Name like '%N'; ---Name variable ends with a N.
		_ exactly one character must occupy that postion
			ex. where Name like 'T_m%';-begins with a T then a specific character then
			a m then whatever.(it could be Tom, Tommy, Tim, Timothy etc)
			*/
proc print data=orion.customer_dim;
	where customer_name like '%M%';
run;/*shows customer whose names has a capital M in in.*/
			
			/*id statement replaces obs column. variable specfied replaces obs in results*/
proc print data=orion.customer_dim;
	where customer_age=21;
	id customer_id;
run;
		/*Practice*/
proc print data=orion.order_fact noobs;
	sum total_Retail_Price;
	where total_retail_price > 500;
	id customer_id;
	var order_id order_type quantity total_retail_price;
run;


		/*<out=output-SAS-data-set> specifies an output for the data set
			if not used SAS automatically replaces the dataset with the rearranged
			data set*/
		/*proc sort statement.*/
proc sort data=orion.customer_dim 
	out=work.customer_sort;/*out statement is included with the sort semi-colon. if not added data will permanently be changed*/
	by descending customer_id;/*if by desc. isn't add it will automatically ascend.*/  
run;

proc sort data=orion.sales
	out=work.sales2;
	by country descending salary;
run;
		/*how do you want to group the results. by country? below ex*/
proc print data=work.sales2;
by country;/*in the PROC PRINT by gives the var a different data set result*/
run;
		/*sort by gender and country and create data set in work*/
proc sort data=orion.sales
          out=work.sorted;
   by gender country;*All males from the US doesn't show. why??;
run;
		/*must be the first variable in the sort statement to group the results by */
proc print data=work.sorted; 
   by Gender;
run;
/*Subsetting in the PROC SORT step is more efficient
It selects and sorts only the required observations.*/
proc sort data=orion.sales
	  out=work.sales3;
   by Country descending Salary;
   *where salary<25500; /*Added statement*/
run;

proc print data=work.sales3 noobs;
   by Country;
   sum Salary;
   var First_Name Last_Name Gender Salary;
run;
		/*practice level 1*/
proc sort data=orion.employee_payroll
	out=sort_salary;
	by salary;
run;

proc print data=sort_salary;
run;
		/*Practice level 2*/
proc sort data=orion.orders 
          out=work.custorders nodupkey  /*create data set without duplicate by variables*/
          dupout=work.duplicates;/*dupout allows data set containing duplictes to exist*/
   by Customer_ID;
run;

proc print data=work.custorders;
run;
		/*Producing Detail Reports Practice*/
		/*Level 1*/
proc sort data=orion.employee_payroll
	out=sort_salary;
	by salary;
run;

proc print data= sort_salary;
run;
		/*Level 2*/
proc sort data=orion.employee_payroll
	out=sort_sal;
	by Employee_Gender descending salary;
run;

proc print data=sort_sal noobs;
	var employee_id salary marital_status;
	where employee_term_date is missing and salary>65000;/*where employee_term_date='.'; doesn't work!*/
	by employee_gender;
	sum salary;
run;
		/*challenge*/
proc print data=orion.orders;
run;

proc sort data=orion.orders
	out=sorted_orders nodupkey
	dupout=duplicates;
	by customer_id;
run;

proc print data=work.duplicates;

run;

/*change the variables' data set name label must be in the proc print statement
	as well as a label statement identifing the variable to change. syntax below*/
	/**/
proc sort data=orion.sales
	out=sorted_sales;
	by gender employee_id;
run;
				
proc print data=sorted_sales label;*proc print--must add label statement to display desired labels;
	var employee_id first_name Last_name gender;
	label employee_id='Employee #'
		first_name='First Name'
		last_name='Last Name'
		gender='Sex';
	by gender;
run;
		/*'SPLIT=' allows line breaks in column heading. add a character within
		the split quotations and then add that specific character within the variables
		new name in the label statement.*/
proc print data=orion.sales split='*' noobs;/*proc print recognize split= and label to print labels. */
	var last_name salary;
	label employee_id='Sales ID'
		Last_name='Last*Name'
		salary='Annual*Salary';
	id employee_id;	
run;

		/*Enhancing Reports level 1*/
title1 'Australian Sales Employees';
title2 'Senior Sales Representatives';
footnote1 'Job_Title: Sales Rep.IV';

proc print data=orion.sales noobs;
   where Country='AU' and 
         Job_Title contains 'Rep. IV';
	var employee_id first_name Last_name gender salary;
run;
title;
footnote;
		/*Enhancing Reports level 2*/
title 'Entry-level Sales Representatives';
footnote 'Job_Title: Sales Rep. I';

proc print data=orion.sales noobs split='*';
   where Country='US' and 
         Job_Title='Sales Rep. I';
   var Employee_ID First_Name Last_Name Salary;
   label Employee_ID= 'Employee*ID'
   	first_name='First*Name'
   	last_name='Last*Name'
   	salary='Annual*Salary';
run;

title;
footnote;
		/*Enhancing Reports Challenge*/
proc sort data=orion.employee_addresses 
          out=work.address;
   where Country='US';
   by State City Employee_Name;
run;

title "US Employees by State";
proc print data=work.address noobs split=' ';
   var Employee_ID Employee_Name 
       City Postal_Code;
   label Employee_ID='Employee ID'
         Employee_Name='Name'
         Postal_Code='Zip Code';
   by State;
run;
title; /*comment*/
		
		
		
		
		
		
		
		
		
		







