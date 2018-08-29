###########################################################################################
#
# Program: trdbm_create_table.awk 
#
# Purpose: Build the create table SQL scripts.
#
# Usage:   Called from the trdb_create_driver.ksh scipt when 'table' is passed in as the
#	   input parameter.
#
# Brillient Corp.
# J Turck
# 1/23/2012
#
# $Author: pxmpb $
#
# $Date: 2014/06/27 18:12:38 $
#
# $Revision: 1.1.1.1 $
#
# $CVSHeader: trdbmLoad/create/trdbm_create_table.awk,v 1.1.1.1 2014/06/27 18:12:38 pxmpb Exp $
# 
# $Log: trdbm_create_table.awk,v $
# Revision 1.1.1.1  2014/06/27 18:12:38  pxmpb
# Original verison of code.
#
#
# Input:   /cdw/datasets/trdb/trdbmProc/trdbmInput/table.txt
#
# Maint:
#
###########################################################################################




BEGIN { FS  = ENVIRON["DATA_REC_FIELD_DELIM"]
        ftt = "true"
        prv_table_name = "x"
        sql             = ""
	scriptbase=ENVIRON["SCRIPTBASE"]
	app=ENVIRON["APP"]
	table_base=ENVIRON["IQ_TABLE_BASENAME"]
	table_owner=ENVIRON["IQ_TABLE_OWNER"]
      }


{
cur_table_name = $2
if (cur_table_name == prv_table_name)
   {
   }
else 
   if ( ftt == "false" )
   {
      end = length(sql)
      if (prv_table_name =="TIN_INFO") 
      {
         sql = substr(sql, 1, end-1) " );"
      }
      else
      {
         sql = substr(sql, 1, end-1) " );"
      }
      run_file = app "_" scriptbase "_" table_base prv_table_name ".sql"
      print sql > run_file
      print "GO" > run_file
      close (run_file)
      sql = ""
      sql = "CREATE TABLE " table_owner"." table_base cur_table_name "("
     
   }
   else
   {
      ftt = "false"
      end  = 0 
      sql = substr(sql, 1, end-1) ");"
      sql = "CREATE TABLE " table_owner"." table_base cur_table_name "("
   }

i=1

while (i <7)
{
   if(i ==3)
      sql =  sql $3 " "

   if((i ==4) && ($4 =="CHAR"))
       sql =  sql $4 "("
   else if((i ==4) && ($4 =="DATETIME"))
       sql =  sql $4 " "
   else if((i ==4) && ($4 =="DECIMAL"))
      sql = sql "NUMERIC("
   else if((i ==4) && ($4 =="NUMERIC"))
      sql = sql "NUMERIC("
   else if((i ==4) && ($4 =="INTEGER"))
      sql =  sql $4 " NULL,"
   else if((i ==4) && ($4 =="TINYINT"))
      sql =  sql $4 " NULL,"
   else if((i ==4) && ($4 =="UNSIGNED INT"))
      sql =  sql $4 " NULL,"
   else if((i ==4) && ($4 =="DATE"))
      sql = sql "VARCHAR(32) NULL,"
   else if((i ==4) && ($4 =="SMALLINT"))
      sql = sql $4 " NULL,"
   else if((i ==4) && ($4 =="TIMESTMP"))
      sql = sql "CHAR(30) NULL,"
   else if((i ==4) && ($4 =="TIME"))
      sql = sql "CHAR(8) NULL,"
   else if((i ==4) && ($4 =="VARCHAR"))
       sql =  sql $4 "("
   else if((i==5) && ($4=="CHAR"))
      sql = sql $5
   else if((i==5) && ($4=="DATETIME"))
      sql = sql $5
   else if((i==5) && ($4=="NUMERIC"))
      sql = sql $5 ","
   else if((i==5) && ($4=="VARCHAR"))
      sql = sql $5
   else if((i==5) && ($4=="DECIMAL")) {
      a = $5 + 2
      sql = sql a ","
      }
   else if((i==5) && ($4=="INTEGER"))
      sql = sql
   else if((i==5) && ($4=="TINYINT"))
      sql = sql
   else if((i==5) && ($4=="UNSIGNED INT"))
      sql = sql
   else if((i==5) && ($4=="DATE"))
      sql = sql
   else if((i==5) && ($4=="SMALLINT"))
      sql = sql

   else if((i==6) && ($4=="CHAR"))
      sql = sql ") NULL,"
   else if((i==6) && ($4=="DATETIME"))
      sql = sql "NULL,"
   else if((i==6) && ($4=="VARCHAR"))
      sql = sql ") NULL,"
   else if((i==6) && ($4=="DECIMAL"))
      sql = sql $6 ") NULL,"
   else if((i==6) && ($4=="NUMERIC"))
      sql = sql $6 ") NULL,"
   else if((i==6) && ($4=="INTEGER"))
      sql = sql
   else if((i==6) && ($4=="TINYINT"))
      sql = sql
   else if((i==6) && ($4=="UNSIGNED INT"))
      sql = sql
   else if((i==6) && ($4=="DATE"))
      sql = sql
   else if((i==6) && ($4=="SMALLINT"))
      sql = sql
i++
}

prv_table_name = cur_table_name

}

END{ 
     end = length(sql)
     sql = substr(sql, 1, end-1) ");"
     run_file = app "_" scriptbase "_" table_base cur_table_name ".sql"
     print sql > run_file
     print "GO" > run_file
   }
