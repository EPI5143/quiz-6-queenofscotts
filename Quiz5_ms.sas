*Determine the proportion of admissions which recorded a diagnosis of diabetes for admissions between  
January 1st 2003 and December 31st, 2004.  Generate a frequency table of frequency of diabetes diagnoses, 
with the denominator being the total number of admissions between January 1st 2003 and December 31st, 2004.
This exercise requires sorting, flat-filing, and linking (merging) tables.
Hints:  
1.	 From the NhrAbstracts dataset, you will have to create a new dataset which contains only unique 
admissions (hraEncWID) with admit dates (hraAdmDtm) between January 1st, 2003 and December 31st, 2004: 
this is your spine dataset.
2.	 From the NhrDiagnosis table you will need to determine if one or more diagnosis codes (hdgcd)  
for diabetes (ICD9 starting with ‘250’ or ICD10 starting with ‘E11’ or ‘E10’) was present for each encounter  
in the diagnosis table and create an indicator variable called DM (=0 for no diabetes codes, =1 for one or more 
diabetes codes). 
3.	You will need to flatten your diabetes diagnoses dataset with respect to encounter ID (hdgHraEncWID).
4.	You will need to link the spine dataset you generated from NhrAbstracts and the flattened diabetes 
diagnoses dataset you generated based on the NhrDiagnosis table using the encounter id’s  from each database 
(renaming as required).
5.	Your final dataset should have the same # of observations (and include all encounter IDs) found in your 
the spine dataset and have an indicator variable, DM which is 1 if any diabetes code was present, and 0 
otherwise.
•	Please provide your final SAS code, and resulting frequency table for the  indicator variable you created 
(plain text so it can be uploaded to Github as a plain text .sas file). You are  encouraged to include inline 
comments to explain the purpose of each step in your program (which may earn you part marks if your code 
doesn’t actually do what it is supposed to).;

*Q1: create library TOH and input dataset;
libname TOH '/folders/myfolders/LargeDatabases/class_data/';
libname ex '/folders/myfolders/LargeDatabases/Workfolder/';

data ex.spine;
set toh.nhrabstracts;
keep hraEncWID hraAdmDtm;
where (datepart(hraAdmDtm)) between '01Jan2003'd and '31dec2004'd;*admission date occurred in 2003 or 2004;
run;

proc sort data=ex.spine out=ex.spine nodupkey;
by hraEncWID;
run;

*Q2: Determine the number of diagnosis codes for diabetes (hdgcd) (ICD9 '250' or ICD10 'E11'or 'E10')
for each encounter;
*STEP 1: Check the 'ribs' dataset;
data ex.ribs;
set toh.nhrdiagnosis;
if hdgcd in:('250' 'E11' 'E10') then DM=1;
else DM=0;
run;

proc freq data=ex.ribs;
table dm;
run;

*Q3: flatten your diabetes diagnoses dataset with respect to encounter ID (hdgHraEncWID);
proc sort data=ex.ribs out=ex.ribber;
by hdghraEncWID;
run; 

Proc means data=ex.ribber noprint;
class hdghraencwid;
types hdghraencwid;/*only output results within encwids (and not overall)*/
var DM;
Output out=ex.ribbers max(DM)=DM n(DM)=count sum(DM)=dm_count;
run;

proc freq data=ex.ribbers;
table count dm dm_count;
run;

*Q4: You will need to link the spine dataset you generated from NhrAbstracts and the flattened diabetes 
diagnoses dataset you generated based on the NhrDiagnosis table using the encounter id’s  from each database 
(renaming as required);

proc sort data=ex.ribbers out=ex.diabetes (rename = hdghraencwid= hraEncWID ) nodupkey;
by hdghraEncWID;
run; 
proc sort data=ex.spine out=ex.admissions nodupkey;
by hraEncWID;
run;

data final;
merge ex.diabetes(in=a) ex.admissions(in=b);
by hraEncWID;
if b;
if DM=. then DM=0;
if count=. then count=0;
if dm_count=. then dm_count=0;
run;

*5.	Your final dataset should have the same # of observations (and include all encounter IDs) found in your 
the spine dataset and have an indicator variable, DM which is 1 if any diabetes code was present, and 0 
otherwise;

proc freq data=final;
tables dm dm_count count;
run;


