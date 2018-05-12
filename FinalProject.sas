%let libref=C:\Users\Hetansh\Desktop\FALL 2017\SAS\project\ames-housng;
libname lect2 "&libref";
PROC IMPORT DATAFILE = "&libref\train.csv" DBMS = CSV out = train REPLACE;
GETNAMES = YES;
RUN;

Proc print data = train;
run;
proc contents data = train order = varnum;
run;
/*Charts to analyze the data*/
PROC SGPLOT;
	HISTOGRAM SalePrice / SCALE = COUNT;
	run;

PROC SGPLOT;
	VBOX SalePrice / CATEGORY = Neighborhood;
	run;
PROC SGPLOT;
	VBOX SalePrice / CATEGORY = HouseStyle;
	run;

proc sgplot;
scatter x = OverallQual y = SalePrice;
run;


*proc corr data = train nosimple;
proc corr data=train;
    var saleprice;
    with MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
    _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd
	Fireplaces GarageCars GarageArea WoodDeckSF OpenPorchSF _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
    EnclosedPorch;
	run;

/*
	MasVnrArea BsmtFinSF1 BsmtUnfSF TotalBsmtSF FirstFlrSF GrLivArea GarageArea
	*/

/*From here we then down select further to the five variables that have a high correlation.
	MasVnrArea TotalBsmtSF FirstFlrSF GrLivArea GarageArea*/

proc corr data=train nosimple rank plots=(scatter);
   var MasVnrArea TotalBsmtSF _1stFlrSF GrLivArea GarageArea;
   with SalePrice;
   RUN;
proc sgscatter data=train;
    compare x=(MasVnrArea TotalBsmtSF _1stFlrSF GrLivArea GarageArea)
            y=saleprice;
			RUN;



/*SIMPLE REGRESSION MODEL*/
proc reg;
  model SalePrice = MasVnrArea;
run;

/*The best continuous Variable using R-Square Selection*/
/*Comparing simple regression model wth different variables*/
proc reg;
  model SalePrice = GrLivArea GarageArea TotalBsmtSF _1stFlrSF MasVnrArea BsmtFinSF1 BsmtUnfSF/
    selection=rsquare start=1 stop=1;
run;
/*Creating individual models*/
proc reg;
  model SalePrice = GrLivArea;
run;

proc corr data=train nosimple rank plots=(scatter);
   var OverallQual GarageCars YearBuilt FullBath GarageYrBlt Fireplaces;
   with SalePrice;
   RUN;
proc reg;
  model SalePrice = OverallQual;
run;
/*MULTI REGRESSION MODEL*/
proc reg; /*MODEL 1*/
  model SalePrice = GrLivArea MasVnrArea;
run;

proc reg;
  model SalePrice = GrLivArea MasVnrArea OverallQual;
run;

/*Using Multiregresson Model : MODEL 1 to predic sales price and add to the dataset*/
data new;
set train;
predSales = 28796+  (93.19394*(GrLivArea)) + (103.34373*(MasVnrArea));
run;

/*Printing new dataset : last two columns Og Sale Price and Predicted Sale Price*/
proc print data = new;
run;
/*
data new;
set train;
predSales = 28796+  (93.19394*(GrLivArea)) + (103.34373*(MasVnrArea));
predSales2 = (51.918*(GrLivArea)) + (53.709*(MasVnrArea)) + (30702*(OverallQual)) - 90630;
run;
*/
/*Printing new dataset : last two columns Og Sale Price and Predicted Sale Price*/
proc print data = new;
run;
