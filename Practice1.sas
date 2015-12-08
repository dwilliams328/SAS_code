		/*Level 1 examining the data portion of a SAS Data Set.*/
data work.donations;
   infile "&path/donation.dat"; 
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc print data=work.donations;
run;
		/*Level 2 examining the data protion of a SAS Data Set.*/
data work.newpacks;
   input Supplier_Name $ 1-20 Supplier_Country $ 23-24 
         Product_Name $ 28-70;
   datalines;
Top Sports            DK   Black/Black
Top Sports            DK   X-Large Bottlegreen/Black
Top Sports            DK   Comanche Women's 6000 Q Backpack. Bark
Miller Trading Inc    US   Expedition Camp Duffle Medium Backpack
Toto Outdoor Gear     AU   Feelgood 55-75 Litre Black Women's Backpack
Toto Outdoor Gear     AU   Jaguar 50-75 Liter Blue Women's Backpack
Top Sports            DK   Medium Black/Bark Backpack
Top Sports            DK   Medium Gold Black/Gold Backpack
Top Sports            DK   Medium Olive Olive/Black Backpack
Toto Outdoor Gear     AU   Trekker 65 Royal Men's Backpack
Top Sports            DK   Victor Grey/Olive Women's Backpack
Luna sastreria S.A.   ES   Hammock Sports Bag
Miller Trading Inc    US   Sioux Men's Backpack 26 Litre.
;
run;

proc contents data=work.newpacks;
run;