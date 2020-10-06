
%let path=\\dombpn\root_part\Marketing_Relationnel\Chihab_Partagé\1 - ETUDES\AK - E023 - CRE vs Mots cles vs Projet 06-20;

LIBNAME COMM "&path.\LIBRARY";

data swork.DATASET ; 
set COMM.DATASET ; run ;

%macro import_excel(MTABLE=label,MFIC=label);
PROC import 
	DATAFILE = &MFIC. 
    OUT = &MTABLE. 
    DBMS = excel REPLACE; 
	GETNAMES=YES;
RUN;
%mend;

/* Import TABLE PROFILS */
%import_excel(MTABLE=SWORK.PROFILS,MFIC="&path.\Donnees\PROFILS.xlsx") ;

/* Import TABLE MOMENT VIE */
%import_excel(MTABLE=SWORK.MOMENTVIE,MFIC="&path.\Donnees\MOMENTVIE.xlsx") ;

/* Import TABLE KEYWORD BESOIN */
%import_excel(MTABLE=SWORK.BESOIN,MFIC="&path.\Donnees\keywords_besoins.xlsx") ;

/* LIST PROFILS */ 
rsubmit; 
/* Controls the type of SAS variable names that can be used or created during a SAS session */
options validvarname = any ;
/*specifies that a SAS data set name, a SAS data view name, or an item store name must follow these rules: COMPATIBLE | EXTEND */
options VALIDMEMNAME = EXTEND;

%Macro Loop_KEYWORD( TABLE=LABEL );

proc sql  noprint ; 
 select  distinct(&TABLE.) into : LIST separated by ',' 
 from &TABLE. ; 

select  distinct(compress(translate(lowcase(&TABLE.),"aaceeeeiiouu","àâçéèêëîïôùû-_'")))  into   :LIST1 separated by ',' 
 from &TABLE. ; 
quit; 

%put LIST = &LIST.;
%put List1 = &List1; 
 
%let nwords= %sysfunc(countw(%quote(&LIST ), %str(,) )) ;
%put nwords= &nwords; 

data &TABLE._CRE ; 
set DATASET ;
COMM= UPCASE(translate(lowcase(LICMT),"aaceeeeiiouu","àâçéèêëîïôùû'"));
run; 

%do i=1 %to &nwords;
/* Recuperer les mots clefs associés à chaque besoin/PROFILS */ 
proc sql noprint  ; 
	select  distinct(UPCASE(translate(lowcase(KEYWORD),"aaceeeeiiouu","àâçéèêëîïôùû'")))  into   :List_KEYWORD separated by ',' 
	from  &TABLE.  
	where  &TABLE.="%scan(%quote(&LIST.) , &i.,%str(,))"; 
quit; 

%put List_KEYWORD = &List_KEYWORD;
%let nKEYS= %sysfunc(countw(%quote(&List_KEYWORD), %str(,) )) ;
%put nKEYS= &nKEYS; 

data &TABLE._CRE;
	set &TABLE._CRE ;
		format %UPCASE(%scan(%quote(&List1.) , &i.,%str(,))) 3.;

		%UPCASE(%scan(%quote(&List1.) , &i.,%str(,) )) = ifn(FINDW(%UPCASE(COMM), "%UPCASE(%scan(%quote(&List_KEYWORD.),1,%str(,)))")>0 ,1,0) ;
		%if &nKEYS. = 1 %then %do;
		run;
		%end;

		%if &nKEYS. > 1 %then %do;
			%do j=2 %to &nKEYS;
			%UPCASE(%scan(%quote(&List1.) , &i.,%str(,) )) = max( ifn(FINDW(%UPCASE(COMM), "%UPCASE(%scan(%quote(&List_KEYWORD.),&j.,%str(,)))")>0 ,1,0) ,%UPCASE(%scan(%quote(&List1.) , &i.,%str(,))) ) ;
			%end;
		run;
		%end;		
%end;
%mend;
endrsubmit;

rsubmit; 
%Loop_KEYWORD(TABLE=PROFILS);
%Loop_KEYWORD(TABLE=besoin);
%Loop_KEYWORD(TABLE=momentvie);

proc means data = momentvie_cre sum ; var DECEDER--VOITURE ; run ; 
proc means data = PROFILS_CRE sum ; var CONSICIENTISE--TOURBILLONSDELAVIE ; run ; 
proc means data = BESOIN_cre sum ; var BAQ--PREVOYANCE ; run ; 

data test ; set PROFILS_CRE ( where = (iselection >0 )) ; run ;

endrsubmit; 



rsubmit;
options validvarname=any;
%MACRO RB_DETECTION(SUFFIXE=LABEL);

proc sql;
select  distinct(translate(lowcase('max('||compress(strip(&SUFFIXE.),'-_ ')|| ') as ' ||compress(strip(&SUFFIXE.),'-_ ') ),"aaceeeeiiouu","àâçéèêëîïôùû-_'")) into  :LIST1 separated by ',' 
from &SUFFIXE. ; 
quit; 

%LET VAR_CRE = %STR(&LIST1);;
/*%put VAR_CRE = &VAR_CRE; */

proc sql ; 
create table RB_&SUFFIXE._CRE as 
select CODE_RB , 
%UNQUOTE(%NRBQUOTE(%UPCASE(&VAR_CRE.))) 
from &SUFFIXE._CRE 
group by CODE_RB 
;quit;
%mend;

%RB_DETECTION(SUFFIXE=PROFILS);
%RB_DETECTION(SUFFIXE=BESOIN);
%RB_DETECTION(SUFFIXE=momentvie);
endrsubmit;

