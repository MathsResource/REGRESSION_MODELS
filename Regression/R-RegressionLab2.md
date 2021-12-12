Special Laboratory (Weeks 5)
=============================================
Working Directory

The working directory is the pathname for the default directory that the R environment will work with. To determine the current working directory we use the getwd() command, leaving the argument field empty . To specify a new working directory we use the command setwd(), specifying the pathname of the working directory in the argument field. 

Run the following commands.
*getwd()*
*setwd(“C:/WorkArea”)*

Run getwd() a second time to check that you were successful.

### Data Import

Reading in a CSV file: In SULIS there is a file called LabEData1.csv. Save this file to C:/WorkArea . (Remark: it will save itself as “LabCdata.csv”. This is a SULIS related quirk)

Remember to include the argument header = TRUE. This specifies that the first value is each column is in fact the variable name. 


*newdata = read.csv("LabCdata.csv",header =TRUE)*

Type the name of the data set to make sure it has loaded. 

On your submission sheet, write down the first quartile, median and third quartile for each column. Also write down the output for the following commands.

mode(newdata) 
class(newdata)

### Paired t-test

Paired measurements are measurement where in the corresponding observation in both datasets are related to the same case (i.e. same patient or item. A paired T test is used to determine whether there is a significant difference between the variables, on average.


On your submission sheet, write down the p-value and confidence interval for the following test. 

(Recall the paired measurements by methods ISE and GRAV from previous classes. ISE and grav data is found on LabCScripts.pdf)

t.test (ISE, Grav , paired=TRUE)

### Packages

The MethComp package is a package of statistical software used to perform Method Comparison Procedures testing how well two methods of measurement agree with each other.
To install the package, run the following piece of code, then select options accordingly (e.g. select Ireland as your mirror ).
install.packages(“MethComp”)

### Method Comparison Procedures

First we compute the following values:

standard deviation of case-wise difference
mean of case-wise differences 

Limits of agreement are computed using the mean and standard deviation of casewise differences (see code used to compute Low and Upp below ).

diff = ISE-grav
sd(diff)
mean(diff)
Low = mean(diff) - 2*sd(diff)
Upp = mean(diff) + 2*sd(diff)
Low ; Upp

Write down the mean, the standard deviation and the lower and upper limit of agreement on your submission sheet.

Two methods are said to be in agreement if the limits of agreement are acceptably narrow. However Interpretation is hinder by the fact that what constitutes an acceptable level is not clear. Hence other approaches have been adopted for method comparison.


The mean of the case-wise differences is used as an estimate for the inter-method bias : the tendency of one method to systematically outmeasure the other.

Another approach for method comparison studies is Deming Regression. To use Deming Regression, we simply load the Methcomp Package, and run the following piece of code.

library(MethComp)
deming(ISE,Grav)




What is the regression equation according to the Deming method?
