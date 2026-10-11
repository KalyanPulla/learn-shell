source common.sh
component_name=catalogue
echo Log file output: ${log_file} 

schema_load=true
schema_type=mysql
schema_files="schema.sql, appuser-sql, master-data.sql"
golang_app
