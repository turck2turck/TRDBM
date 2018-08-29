#!/usr/bin/env ksh
set +x
umask 137
###########################################################################################
#
# Program: trdbm_create_driver.ksh
#
# Purpose: To create and execute TRDBM (merge) scripts.
#
# Usage:   
#	trdbm_create_driver.ksh <action> <extcycle or 'all'>
#	action - table, index, merge or tin
#	
# 	Uses corresponding awk script and text file 
#		--> note trdbm.index.txt is copied from trdbm.table.txt	
#	AWK scripts are:
#		trdbm_create_alter.awk
#		trdbm_create_index.awk
#		trdbm_create_index2.awk  (CR6194 Index Req for TIN like columns)
#		trdbm_create_table.awk
#		trdbm_create_tin.awk
#	The merge scripts are pre written and stored by extcycle.
#
# Brillient Corp.
# J Turck
# 5/17/2013
#
# Input:   Enter the list of table you want to process. 
#	   /cdw/datasets/trdb/trdbmProc/trdbmInput/trdbm_build_tables.txt
#
#  $Author: 8gmpb $
#
#  $Date: 2015/04/22 13:30:01 $
#
#  $Revision: 1.6 $
#
#  $CDWHeader$
#
#  $Log: trdbm_create_driver.ksh,v $
#  Revision 1.6  2015/04/22 13:30:01  8gmpb
#  CR6194 - Index Requirements for TIN like Columns
#
#  Revision 1.5  2015/03/02 14:08:52  8gmpb
#  Checked in to insure 'iq_table_owner' is part of the script.
#
#  Revision 1.4  2014/09/22 18:41:27  8gmpb
#  Merge remaining years for TRDBM. Extcycle 200252 through 200853.
#
#  Revision 1.3  2014/07/14 15:18:58  8gmpb
#  July 14, 2014 fixed the move of $IN_RUN to the output directory only when the
#  file is created during the table or index build. Not there to move when a merge
#  command is executed.
#
#  Revision 1.2  2014/07/11 19:16:15  8gmpb
#  Clean up of commented out lines and other changes made for testing and never
#  removed
#
#  Revision 1.1.1.1  2014/06/27 18:12:38  pxmpb
#  Original verison of code.
#
#
#  Note - the table and indexes SQLs are built dynamically. The merge and view SQLs are 
#         pre-written. 
#         The merge of the F1040 table needs to be done first since the schedules are built     
#         from the F1040 table. There is only one view - TRDBM_F1040
# 
# J.Turck 7/9/2014 Modify directory name to include extcycle being executed. 
#
# J.Turck CR5970 Fix TRDBM_TIN_INFO 
#
# J.Turck 4/2/2015 CR6052 - Added additional extract cycles for 201352 and 201453
#
# J.Turck 4/15/2015 CR6197 Added additional index awk script
#
###########################################################################################

f_usage()

{
   echo ""
   echo "Please pass in what type of process you would like to run."
   echo ""
   echo "       ------> 'table' to create and execute the table scripts."
   echo "       ------> 'alter' to create and execute the alter scripts."
   echo "       ------> 'index' to create and execute the index scripts."
   echo "       ------> 'merge' to create and execute the merge scripts."

   echo " Second positional parameter is EXTCYCLE (extract year and cycle) to be processed:"
   echo "       ------> yyyycc, e.g., 201114, 'ALL' to process all years"
   echo ""

   exit 1
}

function f_initialize {
   #--------------------------------------------------------------------------------
   #  Setup variables 
   #--------------------------------------------------------------------------------
   
   export USER=`echo ${HOME}|awk -F\/ '{print $4}'`
   export APP=trdbm
   
   export SCRIPTBASE=$1
   export SCRIPTNAME=trdbm_create_driver.ksh 

   export EXTCYCLE=$2
   
   echo "export EXTCYCLE =>$EXTCYCLE<="

   export IN_DATA=${BASE_DIR}/trdbmInput
   
   # The list.run file is the driver input of what tables will be processed. A complete
    
   export IN_LST=${IN_DATA}/${APP}_build_tables.txt

    
   export IN_TXT=${IN_DATA}/${APP}_${SCRIPTBASE}.txt
   export IN_RUN=${IN_DATA}/${APP}_${SCRIPTBASE}.run
   export IN_SEL=${IN_DATA}/${APP}_${SCRIPTBASE}.sel
   export IN_SEL_COL=${IN_DATA}/${APP}_${SCRIPTBASE}.sel_col

   export SQL_DIR=${BASE_DIR}/scripts/${EXTCYCLE}
   export VIEW_DIR=${BASE_DIR}/scripts/views
   export patt=`mktemp -p. patt.XXXXX`
  

   DTS=`date '+%Y%m%d_%H%M%S'`
   export OUTDIR=${BASE_OUTPUT_DIR}/create/createTables_${SCRIPTBASE}_${EXTCYCLE}.${DTS}
   mkdir ${OUTDIR}
   chmod -R 777 ${OUTDIR}

   export CREATE_LOG_FILE=${OUTDIR}/CREATE_LOG_${SCRIPTBASE}.${DTS}

   export BUILD_LOG_FILE=${OUTDIR}/BUILD_LOG_${SCRIPTBASE}.${DTS}

   #
   # Copy the table.txt input file to index.txt input file. 
   #

   if [[ ${SCRIPTBASE} == "index" ]]; then
      cp ${IN_DATA}/${APP}_table.txt ${IN_DATA}/${APP}_index.txt
   fi

   if [[ ${SCRIPTBASE} == "merge" ]]; then
      cp ${IN_DATA}/${APP}_build_tables.txt ${IN_DATA}/${APP}_${SCRIPTBASE}.sel
   fi

   if [[ ${SCRIPTBASE} == "tin" ]]; then
      cp ${IN_DATA}/${APP}_build_tables.txt ${IN_DATA}/${APP}_${SCRIPTBASE}.sel
   fi

   if [[ ${SCRIPTBASE} == "view" ]]; then
      cp ${IN_DATA}/${APP}_build_tables.txt ${IN_DATA}/${APP}_${SCRIPTBASE}.sel
   fi

   case "${EXTCYCLE}" in
          "201453") 
             export INDV_1040_TABLE=TRDBM_F1040_14
             ;;
          "201352") 
             export INDV_1040_TABLE=TRDBM_F1040_13
             ;;
          "201253") 
             export INDV_1040_TABLE=TRDBM_F1040_12
             ;;
          "201152") 
             export INDV_1040_TABLE=TRDBM_F1040_11
             ;;
          "201052") 
	     export INDV_1040_TABLE=TRDBM_F1040_10
             ;;
          "200952") 
             export INDV_1040_TABLE=TRDBM_F1040_09 
             ;;
          "200853") 
             export INDV_1040_TABLE=TRDBM_F1040_08 
             ;;
          "200752") 
             export INDV_1040_TABLE=TRDBM_F1040_07 
             ;;
          "200652") 
             export INDV_1040_TABLE=TRDBM_F1040_06 
             ;;
          "200552") 
             export INDV_1040_TABLE=TRDBM_F1040_05 
             ;;
          "200452") 
             export INDV_1040_TABLE=TRDBM_F1040_04 
             ;;
          "200352") 
             export INDV_1040_TABLE=TRDBM_F1040_03 
             ;;
          "200252")
             export INDV_1040_TABLE=TRDBM_F1040_02 
             ;;
          "200152")
             export INDV_1040_TABLE=TRDBM_F1040_01 
             ;;
          "200052")
             export INDV_1040_TABLE=TRDBM_F1040_00 
             ;;
          "199952")
             export INDV_1040_TABLE=TRDBM_F1040_99 
             ;;
   esac
}

#----------------------------------------------------------------------------------

function f_create_echo {
   echo $* >> ${CREATE_LOG_FILE}
}


function f_build_echo {
   echo $* >> ${BUILD_LOG_FILE}
}
   
function f_outputConfig {

   f_build_echo ""
   f_build_echo "Command Line Arguments:"
   f_build_echo ""
   f_build_echo "   Process Type         = $SCRIPTBASE"
   f_build_echo "   Process Extcycle     = $EXTCYCLE"
   f_build_echo ""
   f_build_echo "Config File Parameters: " 
   f_build_echo "   IQ_TABLE_BASENAME    = $IQ_TABLE_BASENAME"
   f_build_echo "   IQ_TABLE_OWNER       = $IQ_TABLE_OWNER"
   f_build_echo "   INPUT_DATA_DIR       = $INPUT_DATA_DIR"
   f_build_echo "   BASE_OUTPUT_DIR      = $BASE_OUTPUT_DIR"
   f_build_echo "   DATA_REC_FIELD_DELIM = $DATA_REC_FIELD_DELIM"
   f_build_echo ""
   f_build_echo "   IQ_SERVER            = $IQ_SERVER"
   f_build_echo "   IQ_DATABASE          = $IQ_DATABASE"
   f_build_echo "   IQ_USER_ID           = $IQ_USER_ID"
   f_build_echo ""
   f_build_echo "Date Run: "
   f_build_echo ""
   f_build_echo "   ${DTS}"
}
#-----------------------------------------------
# Special processing for PTIN, STIN and VTIN
#-----------------------------------------------


function f_special_processing {
echo "in the SP function."
isql -U${IQ_USER_ID} -S${IQ_SERVER} -D${IQ_DATABASE} -P${IQ_PASSWORD} -w 512 <<-% >> ${BUILD_LOG_FILE}

INSERT INTO ${IQ_TABLE_BASENAME}INDV_TIN_INFO (UNMASKED_TIN, TIN)
SELECT distinct(substring(UNMASKED_PREPARER_PTIN,2,8)), PREPARER_PTIN_MASK
FROM ${IQ_TABLE_BASENAME}INDV_TAXPAYER_INFO
WHERE UNMASKED_PREPARER_PTIN is not NULL and
not exists (select 1 from ${IQ_TABLE_BASENAME}INDV_TIN_INFO where TIN = PREPARER_PTIN_MASK)
  and EXTCYCLE = ${EXTCYCLE};
GO

INSERT INTO ${IQ_TABLE_BASENAME}INDV_TIN_INFO (UNMASKED_TIN, TIN)
SELECT distinct(substring(UNMASKED_PREPARER_VTIN,2,8)), PREPARER_VTIN_MASK
FROM ${IQ_TABLE_BASENAME}INDV_TAXPAYER_INFO
WHERE UNMASKED_PREPARER_VTIN is not NULL and
not exists (select 1 from ${IQ_TABLE_BASENAME}INDV_TIN_INFO where TIN = PREPARER_VTIN_MASK)
  and EXTCYCLE = ${EXTCYCLE};
GO

INSERT INTO ${IQ_TABLE_BASENAME}INDV_TIN_INFO (UNMASKED_TIN, TIN)
SELECT distinct(substring(UNMASKED_PREPARER_STIN,2,8)), PREPARER_STIN_MASK
FROM ${IQ_TABLE_BASENAME}INDV_TAXPAYER_INFO
WHERE UNMASKED_PREPARER_STIN is not NULL and
not exists (select 1 from ${IQ_TABLE_BASENAME}INDV_TIN_INFO where TIN = PREPARER_STIN_MASK)
  and EXTCYCLE = ${EXTCYCLE};
GO

INSERT INTO ${IQ_TABLE_BASENAME}INDV_TIN_INFO (UNMASKED_TIN, TIN)
SELECT distinct(substring(UNMASKED_PREPARERS_PTIN,2,8)), PREPARERS_PTIN_MASK
FROM ${IQ_TABLE_BASENAME}INDV_TAXPAYER_INFO
WHERE UNMASKED_PREPARERS_PTIN is not NULL
  and substring(UNMASKED_PREPARERS_PTIN,1,1) not like "[0-9]%"
  and not exists (select 1 from ${IQ_TABLE_BASENAME}INDV_TIN_INFO where TIN = PREPARERS_PTIN_MASK)
  and EXTCYCLE = ${EXTCYCLE};
GO

INSERT INTO ${IQ_TABLE_BASENAME}INDV_TIN_INFO (UNMASKED_TIN, TIN)
SELECT distinct UNMASKED_PREPARERS_PTIN, PREPARERS_PTIN_MASK
FROM ${IQ_TABLE_BASENAME}INDV_TAXPAYER_INFO
WHERE UNMASKED_PREPARERS_PTIN is not NULL
  and substring(UNMASKED_PREPARERS_PTIN,1,1) like "[0-9]%"
  and not exists (select 1 from ${IQ_TABLE_BASENAME}INDV_TIN_INFO where TIN = PREPARERS_PTIN_MASK)
  and EXTCYCLE = ${EXTCYCLE};
GO

INSERT INTO ${IQ_TABLE_BASENAME}INDV_TIN_INFO (UNMASKED_TIN, TIN)
SELECT distinct(substring(UNMASKED_PREPARER_PTIN,2,8)), PREPARER_PTIN_MASK
FROM ${IQ_TABLE_BASENAME}INDV_TAXPAYER_INFO
WHERE UNMASKED_PREPARER_PTIN is not NULL and
not exists (select 1 from ${IQ_TABLE_BASENAME}INDV_TIN_INFO where TIN = PREPARER_PTIN_MASK)
   and EXTCYCLE = ${EXTCYCLE};
GO

%

}


function f_cleanUp {
   mv ${IN_SEL} ${OUTDIR}

if [[ ${SCRIPTBASE} == 'table' ||     \
      ${SCRIPTBASE} == 'alter' ||     \
      ${SCRIPTBASE} == 'index' ]]; then
   mv ${IN_RUN} ${OUTDIR}
fi

   rm -f ${BASE_DIR}/create/patt.* >/dev/null 2>&1
   rm -f ${IN_DATA}/${APP}_index.txt >/dev/null 2>&1
}


#-----------------------------------------------
#  Main:
#-----------------------------------------------

if [[ $# -ne 2 ]]; then
  f_usage
fi

#-----------------------------------------------
#     Source the load config file to set up environment variables.
#     Source the .pw file in home directory to set sybase password for user
#-----------------------------------------------


. ../config/trdbm_conf

if [[ -s ${HOME}/.pw ]]; then
   . ${HOME}/.pw
else
   echo ""
   echo ""
   echo "ERROR: password file ${HOME}/.pw is empty or does not exist"
   echo "       processing terminating now."
   echo ""
   echo ""
   exit 99
fi

f_initialize $*

f_outputConfig

#-----------------------------------------------
# Build table and columns input list.
#-----------------------------------------------

if [[ ${SCRIPTBASE} == 'table' ||     \
      ${SCRIPTBASE} == 'alter' ||     \
      ${SCRIPTBASE} == 'index' ]]; then

   echo "\nProcessing ${SCRIPTBASE}\n"
   #
   #  Process dates or indexes or dates
   #

   > ${IN_RUN}
   
   cat ${IN_LST}| while read i 
   do
      >${patt}
      cat > ${patt} <<-%
	TRDBLOAD\|${i}\|
	%

      cat ${IN_TXT} | /usr/xpg4/bin/grep -E -f ${patt}  >> ${IN_RUN}
   
      es=${?}
      if [[ ${es} -ne 0  ]]; then
         echo ""
         echo "WARNING. The ${i} table not found in file: ${IN_TXT} "  >> ${CREATE_LOG_FILE}
         echo ""
         echo "WARNING. The ${i} table not found in file: ${IN_TXT} "  
         echo ""
      fi

      >${IN_SEL}

      cat ${IN_RUN}| awk -F\| '{print $2}' |sort -u > ${IN_SEL} 
      cp ${IN_SEL} ${OUTDIR}
      cp ${IN_RUN} ${OUTDIR}
   done
else
   if [[ ${SCRIPTBASE} == 'tin'  ]]; then

   >${IN_RUN}

   cat ${IN_LST}| while read i
   do
      i=${i}${suffix}
      cat ${IN_TXT} |grep 'TRDBLOAD|'$i'|' >> ${IN_RUN}
      es=${?}
      if [[ ${es} -ne 0 ]]; then
         echo ""
         echo "WARNING. The ${i} table not found in file: ${IN_TXT} "  >> ${CREATE_LOG_FILE}
         echo ""
         echo "WARNING. The ${i} table not found in file: ${IN_TXT} "
         echo ""
      fi
   done
      cat ${IN_RUN}| awk -F\| '{print $3}' |sort -u > ${IN_SEL_COL} 
fi
fi

#-----------------------------------------------
# Execute awk script to build SQL statements.
#-----------------------------------------------
f_create_echo "\n"
f_create_echo "=======> Creating the ${SCRIPTBASE} build scripts.  ${DTS}  <========="
f_create_echo "=======> Using ${IN_LST}                                    <========="
f_create_echo "\n"

echo "the script base is" ${SCRIPTBASE}
echo "=======> Creating the ${SCRIPTBASE} build scripts.  ${DTS}  <========="
echo "Using in data file: " ${IN_RUN}

if [[ ${SCRIPTBASE} == 'table' ||     \
      ${SCRIPTBASE} == 'alter' ||     \
      ${SCRIPTBASE} == 'index' ]]; then
   nawk -f ${APP}_create_${SCRIPTBASE}.awk ${IN_RUN}
   mv ${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}*.sql ${OUTDIR}
fi

if [[ ${SCRIPTBASE} == 'index' ]]; then
   nawk -f ${APP}_create_${SCRIPTBASE}2.awk ${IN_RUN}
   mv ${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}*.sql ${OUTDIR}
fi

if [[ ${SCRIPTBASE} == 'tin' ]]; then
   nawk -f ${APP}_create_${SCRIPTBASE}.awk ${IN_RUN}
   cat ${IN_RUN}| awk -F\| '{print $3}' |sort -u > ${IN_SEL_COL} 
   ##mv ${BASE_DIR}/create/trdbm_${SCRIPTBASE}_TRDBM_INDV_TIN_INFO_UNMASKED_*.sql ${OUTDIR}/
   cat ${IN_SEL_COL} |while read i
   do
     cat ${BASE_DIR}/create/trdbm_${SCRIPTBASE}_TRDBM_INDV_TIN_INFO_UNMASKED_${i}.sql |sed "s/???/"${EXTCYCLE}"/g" > ${OUTDIR}/0.sql
     mv ${OUTDIR}/0.sql ${OUTDIR}/trdbm_${SCRIPTBASE}_TRDBM_INDV_TIN_INFO_UNMASKED_${i}.sql
   done

##f_special_processing

fi

if [[ ${SCRIPTBASE} == 'merge' ]]; then  
   cat ${IN_LST} |while read i 
   do
      cp ${SQL_DIR}/${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}${i}.sql ${OUTDIR}/0.sql
      cat ${OUTDIR}/0.sql |sed "s/???/"${EXTCYCLE}"/g"  > ${OUTDIR}/1.sql
      cat ${OUTDIR}/1.sql |sed "s/XXX/"${IQ_TABLE_OWNER}.${INDV_1040_TABLE}"/g" > ${OUTDIR}/2.sql
      cat ${OUTDIR}/2.sql |sed "s/iq_table_owner/"${IQ_TABLE_OWNER}"/g" > ${OUTDIR}/3.sql

      ##cat ${OUTDIR}/0.sql |sed "s/???/"${EXTCYCLE}"/g" > ${OUTDIR}/1
      mv ${OUTDIR}/3.sql ${OUTDIR}/${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}${i}.sql
      rm ${OUTDIR}/0.sql
      rm ${OUTDIR}/1.sql
      rm ${OUTDIR}/2.sql
   done
fi

if [[ ${SCRIPTBASE} == 'view' ]]; then  
   cat ${IN_LST} |while read i 
   do
      cp ${VIEW_DIR}/${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}${i}.sql ${OUTDIR}/0.sql
      cat ${OUTDIR}/0.sql |sed "s/iq_table_owner/"${IQ_TABLE_OWNER}"/g" > ${OUTDIR}/1.sql
      mv ${OUTDIR}/1.sql ${OUTDIR}/${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}${i}.sql
   done
fi


#-----------------------------------------------
# Using the input list, execute isql to run 
# the SQL statements created in the previous step. 
#-----------------------------------------------

f_build_echo "\n"
f_build_echo "=======> Executing ${APP} scripts for ${SCRIPTBASE}.     <========="
f_build_echo "\n"

##CR Fix TIN_INFO
if [[ ${SCRIPTBASE} == 'tin' ]]; then
cat ${IN_SEL_COL} |while read col_name
do
   f_build_echo "Processing . . . . ${IQ_TABLE_BASENAME}INDV_TIN_INFO_UNMASKED_${col_name}" 
   case $col_name in
      \#*)
      continue
    ;;
      \\n)
      continue
    ;;
   esac
  

   RUN_TABLE=${IQ_TABLE_BASENAME}${table_name}
   ##isql -U${IQ_USER_ID} -S${IQ_SERVER} -D${IQ_DATABASE} -P${IQ_PASSWORD} -w512 -i${OUTDIR}/${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}INDV_TIN_INFO_UNMASKED_${col_name}.sql >>${BUILD_LOG_FILE}

   es=${?}
   if [[ ${es} -ne 0 ]]; then
      f_build_echo ""
      f_build_echo "FATAL ERROR executing isql in script trdbm_create_driver.ksh input of: ${SCRIPTBASE}"
      f_build_echo "FATAL ERROR executing isql in script trdbm_create_driver.ksh input of: ${SCRIPTBASE}" >> ${BUILD_LOG_FILE}
      f_build_echo "   Exit status = ${es}"
      f_build_echo ""
      f_build_echo ""
      exit 3
   fi
done < ${IN_SEL_COL}

fi


if [[ ${SCRIPTBASE} == 'view' ]]; then
cat ${IN_SEL} |while read table_name
do
   f_build_echo "Processing . . . . ${IQ_TABLE_BASENAME}_F1040 view"
   case $table_name in
      \#*)
      continue
    ;;
      \\n)
      continue
    ;;
   esac


   RUN_TABLE=${IQ_TABLE_BASENAME}${table_name}
   ##isql -U${IQ_USER_ID} -S${IQ_SERVER} -D${IQ_DATABASE} -P${IQ_PASSWORD} -w512 -i${OUTDIR}/${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}${table_name}.sql 
   es=${?}
   if [[ ${es} -ne 0 ]]; then
      f_build_echo ""
      f_build_echo "FATAL ERROR executing isql in script trdbm_create_driver.ksh input of: ${SCRIPTBASE}"
      f_build_echo "FATAL ERROR executing isql in script trdbm_create_driver.ksh input of: ${SCRIPTBASE}" >> ${BUILD_LOG_FILE}
      f_build_echo "   Exit status = ${es}"
      f_build_echo ""
      f_build_echo ""
      exit 3
   else
      f_build_echo "No errors in the execution of: ${SCRIPTBASE} TRDBM_F1040 view"
      f_build_echo "No errors in the execution of: ${SCRIPTBASE} TRDBM_F1040 view" >> ${BUILD_LOG_FILE}
   fi
done < ${IN_SEL}

fi


if [[ ${SCRIPTBASE} == 'table' ||     \
      ${SCRIPTBASE} == 'alter' ||     \
      ${SCRIPTBASE} == 'index' ]]; then
cat ${IN_SEL} |while read table_name
do
   f_build_echo "Processing . . . . ${IQ_TABLE_BASENAME}${table_name}"
   case $table_name in
      \#*)
      continue
    ;;
      \\n)
      continue
    ;;
   esac
 

   RUN_TABLE=${IQ_TABLE_BASENAME}${table_name}
   ##isql -U${IQ_USER_ID} -S${IQ_SERVER} -D${IQ_DATABASE} -P${IQ_PASSWORD} -w512 -i${OUTDIR}/${APP}_${SCRIPTBASE}_${IQ_TABLE_BASENAME}${table_name}.sql >>${BUILD_LOG_FILE}
   es=${?}
   if [[ ${es} -ne 0 ]]; then
      f_build_echo ""
      f_build_echo "FATAL ERROR executing isql in script trdbm_create_driver.ksh input of: ${SCRIPTBASE}"
      f_build_echo "FATAL ERROR executing isql in script trdbm_create_driver.ksh input of: ${SCRIPTBASE}" >> ${BUILD_LOG_FILE}
      f_build_echo "   Exit status = ${es}"
      f_build_echo ""
      f_build_echo ""
      exit 3
   fi
done < ${IN_SEL}

fi

#-----------------------------------------------------------
# Check whether the execution of SQL statement is successful
#-----------------------------------------------------------

egrep  "SQL Anywhere Error" < ${BUILD_LOG_FILE}
if  [[ $? -eq 0 ]]; then 
    f_build_echo "#----------------------------------------------------" 
    f_build_echo " Executing: ${SCRIPTNAME} for ${SCRIPTBASE} has ERROR!!"                
    f_build_echo "#----------------------------------------------------"
    echo " Executing: ${SCRIPTNAME} for ${SCRIPTBASE} has ERROR!!"         
    exit 1
fi

f_cleanUp

exit 0

