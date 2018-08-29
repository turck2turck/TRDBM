###########################################################################################
#
# Program: trdb_create_mask.awk 
#
# Purpose: Build the create mask SQL scripts.
#
# Usage:   Called from the trdb_create_driver.ksh scipt when 'mask' is passed in as the
#          input parameter.
#
# Brillient Corp.
# J Turck
# 1/23/2012
#
# $Author: 8gmpb $
# 
# $Date: 2014/09/10 19:05:22 $
# 
# $Revision: 1.5 $
# 
# $CVSHeader: trdbLoad/create/trdb_create_mask.awk,v 1.5 2014/09/10 19:05:22 8gmpb Exp $
# 
# $Log: trdb_create_mask.awk,v $
# Revision 1.5  2014/09/10 19:05:22  8gmpb
# CR5129 - Load 2013 Data
#
# Revision 1.4  2013/02/22 13:38:57  pxmpb
# Changed " $3"_MASK to MASKED_"$3 " in generated sql update statement
#
# Revision 1.3  2013/01/22 15:30:45  pxmpb
# - Added "UNMASKED_" to unmasked column names "sql = ..." approx line 83
# - modified generated sql to omit from consideration unmasked tins that have non-numeric characters
#
# Revision 1.2  2012/08/27 14:24:55  pxmpb
#
#  05/08/2012 - RJ Huber - add tax_year so as to only update tables where
#                          YEAR = tax_year where if EXTCYCLE = "ALL" then
#                          process without respect to YEAR column.
#
#  06/01/2012 - J. Turck - Modified YEAR to TRDB_YEAR CR2642
#
#  07/25/2012 - RJ Huber - Modified TRDB_YEAR to EXTCYCLE CR2532
#
#  08/27/2012 - RJ Huber - Added CVS keywords to header
#
# 
#
# Input:   /cdw/datasets/trdb/trdbProc/trdbInput/mask.txt
#
# Maint:
#
# 05/08/2012 - RJ Huber - add tax_year so as to only update tables where
#                         YEAR = tax_year where if EXTCYCLE = "ALL" then
#                         process without respect to YEAR column.
#
# 06/1/2012 - J. Turck - Modified YEAR to TRDB_YEAR CR2642
#
# 07/25/2012 - RJ Huber - Modified TRDB_YEAR to EXTCYCLE CR2532
#
# 10/22/2012 - RJ Huber - Added "UNMASKED_" to unmasked column names
#                         "sql = ..." approx line 83
#
# 11/04/2012 - RJ Huber - modified generated sql to omit from consideration unmasked 
#                         tins that have non-numeric characters
#
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
	table_owner= ENVIRON["IQ_TABLE_OWNER"]

        extcycle   = ENVIRON["EXTCYCLE"]

        if ( extcycle == "ALL" ){ test_year = ""                      }
        else                    { test_year = " and EXTCYCLE = " extcycle }
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


    sql = sql "UPDATE " table_owner"."table_base  $2 " \n"\
              "set  "$3"_MASK" " = cast((0.5 + (1.5 * cast( UNMASKED_"$3" as unsigned int))) \n"                 \
              "                     + (2.0 * sqrt(cast( UNMASKED_"$3 " as unsigned int))) as unsigned int) \n"\
              "where UNMASKED_"$3" is not NULL" test_year " \n"                       \
              "  and ( left(trim(substring(convert(char(9),UNMASKED_"$3"),1,9)) + \"000000000\", 9) \n" \
              "           like \"[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\"  \n"      \
              "      and  substring(convert(char(9),UNMASKED_"$3"),1,9) not like \"        \" \n"      \
              "      );"


   prv_table_name = cur_table_name
}

END{ 
     end = length(sql)
     run_file = app"_"scriptbase"_" table_base cur_table_name".sql"
     print sql > run_file
     print "GO" > run_file
   }
