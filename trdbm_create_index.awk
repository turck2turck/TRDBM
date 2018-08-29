###########################################################################################
#
# Program: trdbm_create_index.awk 
#
# Purpose: Build the create index SQL scripts for TRDBM.
#
# Usage:   Called from the trdbm_create_driver.ksh scipt when 'index' is passed in as the
#          input parameter.
#
# Brillient Corp.
# J Turck
# 1/23/2012
#
# $Author: 8gmpb $
# 
# $Date: 2015/01/07 20:17:00 $
# 
# $Revision: 1.2 $
# 
# $CVSHeader: trdbmLoad/create/trdbm_create_index.awk,v 1.2 2015/01/07 20:17:00 8gmpb Exp $
# 
# $Log: trdbm_create_index.awk,v $
# Revision 1.2  2015/01/07 20:17:00  8gmpb
# Added table owner to prefix of the table.
#
# Revision 1.1.1.1  2014/06/27 18:12:38  pxmpb
# Original verison of code.
#
# 
#
# Input:   /cdw/datasets/trdb/trdbmProc/trdbmInput/trdbm_index.txt
#
# Maint:
#
###########################################################################################


BEGIN { 
        sql = ""
        ftt = "true"
        prv_table_name = "x"

        FS = ENVIRON["DATA_REC_FIELD_DELIM"]

        app = ENVIRON["APP"]
        scriptbase = ENVIRON["SCRIPTBASE"]
        table_base = ENVIRON["IQ_TABLE_BASENAME"]
        table_owner = ENVIRON["IQ_TABLE_OWNER"]
      }


{
   cur_table_name = $2
if (cur_table_name == prv_table_name)
   {
   }
else
   if ( ftt == "false" )
      {
         run_file = app"_"scriptbase"_"table_base prv_table_name".sql"
         print sql > run_file
         print "GO" > run_file
         close (run_file)
         sql = ""
      }
   else
      {
         ftt = "false"
      }
   i=1
   while (i <7)
      {
         
         if ((i ==4) && ($4 =="CHAR") && ($5 <= 2))
               sql = sql "CREATE LF  index " table_base $2"_"$3 "_LF ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="VARCHAR") && ($5 <= 2))
              sql =  sql "CREATE LF  index " table_base $2"_"$3 "_LF ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="TINYINT"))
              sql =  sql "CREATE LF  index " table_base $2"_"$3 "_LF ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="SMALLINT"))
              sql =  sql "CREATE LF  index " table_base $2"_"$3 "_LF ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="CHAR") && ($5 > 2))
              sql =  sql "CREATE HG  index " table_base $2"_"$3 "_HG ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="VARCHAR") && ($5 > 2))
              sql =  sql "CREATE HG  index " table_base $2"_"$3 "_LF ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="DATE") && ($5 > 2))
              sql =  sql "CREATE HG  index " table_base $2"_"$3 "_HG ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="INTEGER"))
              sql =  sql "CREATE HNG index " table_base $2"_"$3 "_HNG ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="UNSIGNED INT"))
              sql =  sql "CREATE HNG index " table_base $2"_"$3 "_HNG ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="DECIMAL"))
              sql =  sql "CREATE HNG index " table_base $2"_"$3 "_HNG ON " table_owner"."table_base $2"("$3");\n"
         else if ((i ==4) && ($4 =="NUMERIC"))
              sql =  sql "CREATE HNG index " table_base $2"_"$3 "_HNG ON " table_owner"."table_base $2"("$3");\n"
         i++
      }

   prv_table_name = cur_table_name
}

END{ 
     end = length(sql)
     run_file = app"_"scriptbase"_"table_base cur_table_name".sql"
     print sql > run_file
     print "GO" > run_file
   }
