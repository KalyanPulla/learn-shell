source common.sh
component_name=catalogue
echo Log file output: ${log_file} 

echo -e "${hs} Install Golang and mysql client ${he}" | tee -a ${log_file}
dnf install mysql8.4 &>>${log_file}

echo -e "${hs} Load Schema, App user, Master Data ${he}" | tee -a ${log_file}
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 < db/schema.sql &>>${log_file}
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 < db/app-user.sql &>>${log_file}
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 ${component_name} < db/master-data.sql &>>${log_file}
status_check

golang_app
