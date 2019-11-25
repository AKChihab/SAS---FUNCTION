/*Resolving Macro Variables in a Server Session*/
/*If you want to use your macro within the server session
You need to use the %SYSLPUT Statement insteade of %let*/

See more about %SYSLPUT ==> http://support.sas.com/documentation/cdl/en/connref/61908/HTML/default/viewer.htm#a002590516.htm

/* IN fact you can use a %let statement within the rsubmit block. Either will generate a global macro variable on the remote server. 
I personally prefer %syslput and %sysrput to help visually keep track of which macro variables are in my session or the remote session. */

/* Example  */ 

%syslput  NUM=757  ; 
*%global NUM;

rsubmit ; 

PROC SQL;
CREATE TABLE CIBLAGE_&NUM. AS
select ID,NAME,AGE,SEXE
FROM V1TABLEINFO ( where = (AGE >= 28 ));

endrsubmit;

PROC EXPORT 
DATA = SWORK.CIBLAGE_&NUM.
OUTFILE = "B:\CIBLAGE_&NUM..txt" 
DBMS = DLM REPLACE;
DELIMITER = '20'x; 
PUTNAMES = NO;
RUN;
