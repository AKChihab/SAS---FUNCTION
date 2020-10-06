
%macro loop_excel(vlist,MFIC=label, MFEUIL=label);
%let nwords=%sysfunc(countw(&vlist));
%do i=1 %to &nwords;
PROC EXPORT 
   DATA =  SWORk.%UPCASE(%scan(&vlist, &i))1
   OUTFILE = "&MFIC.\IMMO_%UPCASE(%scan(&vlist, &i))_2020.xlsx"
   DBMS = EXCEL REPLACE; 
   SHEET=&MFEUIL. ;
RUN;

%end;
%mend;
%loop_excel(&ParamList,MFIC=\\dombpn\root_part\Marketing_Relationnel\Chihab_Partagé\3 - ACTIONS COMMERCIALES\AK 0055 - EnrichiS Cibles Immo Groupe 05-20\Sorties, MFEUIL="CIBLE IMMO");
