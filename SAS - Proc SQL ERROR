ERROR: Invalid value for width specified - width out of range*
/* SOLUTION */ 
STEPS: (YOU would check a couple of things)
1- First, start a new session, then run your code.  Errors have a tendancy to follow over into the next run, so you could see an error from previous submit impacts your current run.

2- Second, is it possible that for some values of features the result is different from the format declared.
  Example: 
  1- Suppose t1 is a new feature that you create, it calculate the numbre of minutes:secondes from the variable secondes
  /* SAS CODE */ 
  
  proc sql;
		create table catix_bpnd as
		select 
        A.secondes,
  cats( put(int(A.secondes/60),z2.),':', put(mod(A.secondes,60),z2.)) as t1
  from A.V0TABLE(where = (	 ETAT='1'))  A 
  ;quit;
  
  then you will get the ERROR: message* in the log because for A.secondes>5999, t1 is grater than 99:59. 
  
  2-a variable of 3 decimals maximum but accidentaly you have a numbre with more than 3 digit (or could have a very tiny decimal part
(0.000000000013 for instance))

This is down to how the computer stores numbers and can happen after divisions and such like.  

Solution Maybe add:
1- Change the parametre of cats function :
  cats( put(int(A.secondes/3600),z2.),':'put(int(A.secondes/60),z2.),':', put(mod(A.secondes,60),z2.)) as t1
2- Use round() function.  


NOTE : Its pretty difficult for us to debug without seeing example data which causes the issue, SAS is a data based programming language. 
