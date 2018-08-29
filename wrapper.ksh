#!/usr/bin/env ksh 

################################################
#echo "start processing 201052 `date`"

#\cp trdbm_build_tables.txt_2010 /export/home/8gmpb/sandbox/trdbmLoad/trdbmInput/trdbm_build_tables.txt

#./trdbm_create_driver.ksh merge 201052 > trdbm_create_driver_merge_201052.out 2>&1

#es=${?}
#if [[ ${es} -ne 0 ]]; then 
#  echo "executing trdbm_create_driver.ksh merge 201052 had a non-zero exit status = ${es} `date`"
#  exit 2
#fi

#################################################

 

echo "start processing 201152 `date`"

\cp trdbm_build_tables.txt_2011 /export/home/8gmpb/sandbox/trdbmLoad/trdbmInput/trdbm_build_tables.txt

./trdbm_create_driver.ksh merge 201152 > trdbm_create_driver_merge_201152.out 2>&1

es=${?}
if [[ ${es} -ne 0 ]]; then 
  echo "executing trdbm_create_driver.ksh merge 201152 had a non-zero exit status = ${es} `date`"
  exit 2
fi

#################################################


echo "start processing 201253 `date`"

\cp trdbm_build_tables.txt_2012 /export/home/8gmpb/sandbox/trdbmLoad/trdbmInput/trdbm_build_tables.txt

./trdbm_create_driver.ksh merge 201253 > trdbm_create_driver_merge_201253.out 2>&1

es=${?}
if [[ ${es} -ne 0 ]]; then 
  echo "executing trdbm_create_driver.ksh merge 201253 had a non-zero exit status = ${es} `date`"
  exit 2
fi

#################################################


echo "end all  processing `date`"

exit 0


