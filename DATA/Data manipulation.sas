/* Add a row number to data */ 

/*  PROC DATA  */ 
data new;
set old;
IDNew=_n_;
run;

/*  SQL  */

proc sql;
create table new as 
  select *,monotonic() as N from  old;
quit;

/*  IDENTIFYING DUPLICATES   */
data TEST ; 
set ID ;
by ID  ; 
if not (first.ID and last.ID ) ;
run; 


/*  If you want creating a group identifier then something like below should work   */

data new;
  set old;
  by var1 var2;  /* data set have must be sorted by var1 var2 */
  if first.var2 then group_id+1;
run;

/* set all missing values to zero for all numerical variables  */

data DATA_FULL;
set DATA_MISS ; 
 array NUM _numeric_;
        do over NUM;
            if NUM=. then NUM=0;
        end;
run;

/* Create a SAS macro variable that contains a list of valuse */ 
/* Methode 1 : using Proc sql (option: into)  */
proc sql noprint;                              
 select distinct(ID) into :ParamList separated by ','  /* U can personalize the separator ;) */
 from TABLE ;
quit;
%put ParamList = &ParamList; 

/*Methode 2 */ 
data _null_;
 length allvars $1000; /* length of the output list */
 retain allvars ' ';  /* initialize the list */ 
 set IMPORT_CAMPAGNES end=eof;
 /* U can personalize the separator */ 
 *allvars = trim(left(allvars))||' '||left(ID); /* ' ' as a separator */
  allvars = catx(',',trim(left(allvars)),ID); /* ',' as a separator */
  if eof then call symput('varlist', allvars);
 run;
%put &varlist;


DATA TABLE2 ;
SET TABLE1( where = (ID in (&ParamList.) /* or in (&varlist.)*/ ))  ;
RUN ;

*/

;*';*";*/;quit;run;
OPTIONS PAGENO=MIN;
proc sql  noprint ; 
create table swork.TTT as  
 select 
case when famille_besoin ="Prévoyance" then Mot_cl_ end  as KEYList_PREV
,case when famille_besoin ="IARD" then  Mot_cl_ end as KEYList_IARD  
, case when famille_besoin ="Epargne" then  Mot_cl_ end as KEYList_EPARG   
,case when famille_besoin ="banque au quotidien" then  Mot_cl_ end  as KEYList_BQ  
,case when famille_besoin ="Crédit" then  Mot_cl_ end  as KEYList_CR  

 into :KEYList_PREV separated by "," ,
	:KEYList_IARD separated by "," ,
	:KEYList_EPARG separated by ",", 
	:KEYList_BQ separated by ","  ,
	:KEYList_CR separated by "," 
 from swork.KEYWORD_BESOIN  ;
quit;

%put KEYList_PREV = &KEYList_PREV; 
%put &KEYList_PREV.;
%LET tt = %NRBQUOTE(&KEYList_PREV.); 
%put &tt.;



/* DATASET of duplicate ID : more than one interview */ 
data test ; 
set DATASET_FINALE ;
by comax  ; 
if not (first.comax and last.comax ) ;
run; 
