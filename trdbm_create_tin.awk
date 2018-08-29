##########################################################################################
#
# Program: trdbm_create_tin.awk 
#
# Purpose: Build the create tin_info SQL scripts.
#
# Usage:   Called from the trdbm_create_driver.ksh scipt when 'tin' is passed in as the
#          input parameter.
#
# Brillient Corp.
# J Turck
# 1/23/2012
#
# $Author: pxmpb $
# $Date: 2013/01/22 15:39:25 $
# $Revision: 1.3 $
# $CVSHeader: trdbLoad/create/trdb_create_tin.awk,v 1.3 2013/01/22 15:39:25 pxmpb Exp $
#
#
# Input:   /cdw/datasets/trdb/trdbProc/trdbInput/tin.txt
#
# Maint:
#
###########################################################################################


BEGIN { 
        sql = ""
        ftt = "true"
        prv_col_name = "x"

        FS = ENVIRON["DATA_REC_FIELD_DELIM"]

        app = ENVIRON["APP"]
        scriptbase = ENVIRON["SCRIPTBASE"]
        table_base = ENVIRON["IQ_TABLE_BASENAME"]
        table_owner = ENVIRON["IQ_TABLE_OWNER"]
      }


{
   cur_col_name = $3
   table_name = $2
 ##  if (cur_col_name == prv_col_name)

   if ( ftt == "false" )
      {
         run_file = app"_"scriptbase"_" table_base table_name"_UNMASKED_" cur_col_name".sql"
      }
   else
      {
         ftt = "false"
         run_file = app"_"scriptbase"_" table_base table_name"_UNMASKED_" cur_col_name".sql"
      }

   print  "DECLARE LOCAL TEMPORARY TABLE t1 (UNMASKED_COL char(9)) ;  " > run_file
   print  "GO  " > run_file
   print  "INSERT INTO t1 (UNMASKED_COL) SELECT distinct right('000000000' + convert(varchar(9),a.UNMASKED_"$3 "),9) " > run_file
   print  "FROM "table_owner".TRDBM_INDV_TAXPAYER_INFO a WHERE a.extcycle = ??? " > run_file
   print  "GO " > run_file
   print  "COMMIT" > run_file
   print  "GO " > run_file
   print  "INSERT INTO "table_owner".TRDBM_INDV_TIN_INFO (UNMASKED_TIN) SELECT UNMASKED_COL from t1 a " > run_file 
   print  "WHERE a.UNMASKED_COL not in (select b.UNMASKED_TIN from "table_owner".TRDBM_INDV_TIN_INFO b) " > run_file
   print  "GO " > run_file
   print  "COMMIT" > run_file
   print  "GO " > run_file
   print  "UPDATE "table_owner".TRDBM_INDV_TIN_INFO  set tin = (SELECT a.TIN " > run_file 
   print  "FROM "table_owner".TRDB_TIN_INFO a, "table_owner".TRDBM_INDV_TIN_INFO b " > run_file 
   print  "WHERE b.UNMASKED_TIN = a.UNMASKED_TIN and b.TIN is NULL) " > run_file
   print  "GO" > run_file
   print  "COMMIT" > run_file
   print  "GO " > run_file
   print  "DROP TABLE t1" > run_file
   print  "GO" > run_file
   print  "COMMIT" > run_file
   print  "GO" > run_file
   
   prv_col_name = cur_col_name
         close (run_file)
}

END{ 
     end = length(run_file)
     run_file = app"_"scriptbase"_" table_base table_name"_UNMASKED_" cur_col_name".sql" 
   }
