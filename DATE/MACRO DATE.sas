/*  SAS function INTNX is used to increment SAS date by a specified number of intervals. */ 
/*PARAMETES : 
FIRST P : Interval is the unit of measurement. It can be days, weeks, months, quarters, years.
      EXP => Month | YEAR | DAY ...
Advanced EXP =>  week1.3 : tuesday | year1.3 :third month and 1st day  |  
Second P : SAS date value which would be incremented.
Third P : is number of intervals by which date is incremented. It can be zero, positive or negative. 
            Negative value refers to previous dates.
Fourth P: Alignment [Optional - Default value: 'beginning'] is where datevalue is aligned within interval prior to being incremented. 
           he values you can specify - 'beginning' ('b' or 'BEGIN'), 'middle' ('m'), 'end' or 'E', 'sameday' or "s" 

*/ 
*APPLICATION;
/* MONDAY OF THE LAST WEEK : ( week1.2 means : second day of the week : monday ) */
%let monday =%sysfunc(intnx(week1.2,%Sysfunc(today()),-1,BEGIN),DATE9.);
%put &monday;
/*18NOV2019*/

/* End of  previous month */ 
%LET DATE_END_MONTH="%sysfunc(intnx(month,%Sysfunc(today()),-1,E),DATE9.)"d ;

%let date = %sysfunc(intnx(year1.2, '01MAY2019'd, 1),DATE9.);
%put &date;
/*01FEB2020*/

%let date = %sysfunc(intnx(year1.7, '01MAY2019'd, 1),DATE9.);
%put &date;
/*01JUL2019*/

/*   CONVERT FORMAT DATE  to YYYYMMDD  */
%let DATE= %eval( %sysfunc(year(&DATE_DEB.))*10000 + %sysfunc(month(&DATE_DEB.))*100 + %sysfunc(day(&DATE_DEB.)) )  ; /*EXp format 20180101 */ 


/* IF the variable|column is a datetime not a date and you want to get the date portion only :*/
/* You need to use DATEPART() function in the output */ 
/*http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a001263753.htm*/

*Exemple; 
proc sql;
select  id,Datepart(date_time) as date_only format =date9. ,

/* DATE JOUR */ 
PROC SQL NOPRINT;
SELECT TODAY() FORMAT DATE9.
INTO :TMP_DATE_ACTUELLE_S
FROM PRV0.P_DATE_PROD_HEBDO
;
QUIT;
