/* View Contents of a SAS Library */
/* While some of the following tasks can be performed with PROC CONTENTS, all of the functionality of PROC CONTENTS
is built directly into PROC DATASETS, alleviating the need for you to learn both procedures.    */
proc datasets lib=work;
 run;
quit

/*To reduce the output to show only datasets, you can add the memtype option and specify data.*/

proc datasets lib=work memtype=data;
 run;
quit
/*  */
/* To view a list of variables and their attributes within a SAS dataset,
you can add the CONTENTS statement within your call to PROC DATASETS and 
specify the dataset for which you would like to see the attributes for: */

proc datasets lib=work memtype=data;
 contents data=class;
run;
quit;

/*  
PROC DATASETS ultimately ends with a quit statement.
This is because PROC DATASETS supports what is known as run-group processing */

/* you can combine two contents statements into a single call of PROC DATASETS.  */
proc datasets lib=work memtype=data; /* List all datasets */
 contents data=class; /* List variables and their attributes for the CLASS dataset */
run;
 contents data=classfit; /* List variables and their attributes for the CLASSFIT dataset */
run;
quit;
