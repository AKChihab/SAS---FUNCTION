/*The most common way to combine two datasets together in SAS is using the SET statement within a Data Step.
Using PROC DATASETS, you can accomplish the same task as the SET statement but in a more efficient way.*/

/* wo datasets can be combined more efficiently because SAS only needs to read in the observations from 
the dataset being appended. When working with many records or “Big Data”, this can be huge time saver.*/
https://www.sascrunch.com/proc-datasets.html#

/* MERGE TWO DATE SETS USING A DATA SET */

/* U can sort the data directly in the data set by using the option sorteby */ 
/* EXP */ 
DATA Entreprise_Expo; 
merge TABLE1 ( where = (CD1='035' and CD2='1' and CD3 ne "" ) sortedby =ID  in = a )
TABLE2( where = (CD2='1' and CD1='035'AND CD4 in ('1','3') and  CD5 >="00501") sortedby =ID  in = b ) 
TABLE3 (WHERE= ( CD56 = '1' and (CD6>0 or CD7>0  or CD8>0 )) sortedby =comax  in = c );
by ID ; /* variable de jointure */ 
if a & b & not c  ;  /* condition de jointure */ 
if first.comax then output;  /* distinct */ 
run;
