*The example creates an error message and uses %PUT &SYSERR to write the return code number (1012) to the SAS log.
/*You can use the value of SYSERR as a condition to determine further action to take 
or to decide which parts of a SAS program to execute. 
SYSERR is used to detect major system errors, such as out of memory or failure of 
the component system when used in some procedures and DATA steps. 
SYSERR automatic macro variable is reset at each step boundary.
For the return code of a complete job, see SYSCC Automatic Macro Variable.*/
data NULL;
   set doesnotexist;
run;  
%put &syserr;
