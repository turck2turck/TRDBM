###########################################################################################
#
# Program: trdb_create_index.awk 
#
# Purpose: Build the create index SQL scripts.
#
# Usage:   Called from the trdb_create_driver.ksh scipt when 'index' is passed in as the
#          input parameter.
#
# Brillient Corp.
# J Turck
# 1/23/2012
#
# $Author: 8gmpb $
# 
# $Date: 2015/04/22 13:31:45 $
# 
# $Revision: 1.1 $
# 
# $CVSHeader: trdbmLoad/create/trdbm_create_index2.awk,v 1.1 2015/04/22 13:31:45 8gmpb Exp $
# 
# $Log: trdbm_create_index2.awk,v $
# Revision 1.1  2015/04/22 13:31:45  8gmpb
# CR6194 - Index Requirements for TIN like Columns
#
# Revision 1.3  2014/09/10 19:01:17  8gmpb
# CR5129 Load 2013 Data
#
# Revision 1.2  2012/08/27 14:30:45  pxmpb
# Added CVS keywords to header
#
# 
#
# Input:   /cdw/datasets/trdb/trdbProc/trdbInput/index.txt
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
         run_file = app"_"scriptbase"_"table_base prv_table_name"2.sql"
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
   while (i <8)
      {
         if ((i ==7) && ($7=="Y") && ($4 =="UNSIGNED INT"))
            sql =  sql "CREATE HG  index " table_base $2"_"$3 "_HG ON " table_owner"."table_base $2"("$3");\n"
         if ((i ==7) && ($7=="Y") && ($4 =="CHAR") && ($5 > 2) && ($3 ~ /UNMASKED_/))
             sql =  sql "CREATE HNG index " table_base $2"_"$3 "_HNG ON " table_owner"."table_base $2"("$3");\n"
         if ((i ==7) && ($7="Y") && ($4 =="INTEGER")&& ($3 ~ /UNMASKED_/))
            sql =  sql "CREATE HG  index " table_base $2"_"$3 "_HG ON " table_owner"."table_base $2"("$3");\n"

         i++
      }     

   prv_table_name = cur_table_name
}

END{ 
     end = length(sql)
     run_file = app"_"scriptbase"_"table_base cur_table_name"2.sql"
     print sql > run_file
     print "GO" > run_file
     close (run_file)
     sql = ""
   }
