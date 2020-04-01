*EPI5143 Winter 2020 Quiz 6.
Due Tuesday March 31st at 11:59PM via Github (link will be provided)
______________________________________________________________________

Using the Nencounter table from the class data:
a) How many patients had at least 1 inpatient encounter that started in 2003?
b) How many patients had at least 1 emergency room encounter that started in 2003? 
c) How many patients had at least 1 visit of either type (inpatient or emergency room encounter) that started in 2003?
d) In patients from c) who had at least 1 visit of either type, create a variable that counts the total number encounters (of either type)-for example, 
a patient with one inpatient encounter and one emergency room encounter would have a total encounter count of 2. Generate a frequency table of total 
encounter number for this data set, and paste the (text) table into your assignment- use the SAS tip from class to make the table output text-friendly
ie: 
options formchar="|----|+|---+=|-/\<>*"; 
*Additional Info/hints
-you only need to use the NENCOUNTER table for this question 
-EncWID uniquely identifies encounters
-EncPatWID uniquely identifies patients
-Use EncStartDtm to identify encounters occurring in 2003
-EncVisitTypeCd identifies encounter types (EMERG/INPT)

-You will need to flatfile to end up 1 row per patient id, and decide on a strategy to count inpatient, emerg and total encounters for each patient to answer each part of the assignment. 
-There are many ways to accomplish these tasks. You could create one final dataset that can be used to answer all of a) through d), or you may wish to create different datasets/use different 
approaches to answer different parts. Choose an approach you are most comfortable with, and include lots of comments with your SAS code to describe what your code is doing 
(makes part marks easier to award and a good practice regardless).

Please submit your solutions through Github as a plain text .sas or .txt file;
*LIBNAME Statement
______________________________________________________________;
libname quiz6 '/folders/myfolders/LargeDatabases/class_data';
libname ex '/folders/myfolders/LargeDatabases/Workfolder';

*_____________________________________________________________
restrict by year
______________________________________________________________;

data ex.data;
set quiz6.nencounter;
keep EncWID EncPatWID EncStartDtm EncVisitTypeCd;
where (datepart(EncStartDtm)) between '01Jan2003'd and '31dec2003'd;*admission date occurred in 2003;
run; 

*_____________________________________________________________
Determine and recode visit type 
______________________________________________________________;

data ex.quiz;
set ex.data;
if EncVisitTypeCd="EMERG" then evisit=1;
if EncVisitTypeCd="INPT" then ivisit=1;
else if EncVisitTypeCd ne . then delete;
run;

Proc means data=ex.quiz noprint;
class EncPatWID;
types EncPatWID;
var evisit ivisit;
Output out=ex.count max(evisit)=emergencounter n(evisit)=ecount
max(ivisit)=inptencounter n(ivisit)=icount;
run;

proc freq data=ex.count;
table ecount emergencounter inptencounter icount emergencounter_count inptencounter_count;
run;


data ex.final; 
set ex.count; 
totcount= icount + ecount; 
run; 

options formchar="|----|+|---+=|-/\<>*"; 
proc printto file='/folders/myfolders/LargeDatabases/Quiz6named.txt' new; 
proc freq data=ex.final order=data; 
table totcount; 
run;
dm 'odsresults; clear';

*________________________________________________________________
Answers to questions
a) 1978 patients had at least one INPATIENT encounter
b) 1074 patients had at least one EMERG encounter
c) 2891 patients had at least one visit of either 
d) see table below 
_________________________________________________________________;


  														The FREQ Procedure

                                                                        Cumulative    Cumulative
                                   totcount    Frequency     Percent     Frequency      Percent
                                   -------------------------------------------------------------
                                          1        2556       88.41          2556        88.41  
                                          2         270        9.34          2826        97.75  
                                          3          45        1.56          2871        99.31  
                                          4          14        0.48          2885        99.79  
                                          7           1        0.03          2886        99.83  
                                          5           3        0.10          2889        99.93  
                                          6           1        0.03          2890        99.97  
                                         12           1        0.03          2891       100.00  



