source common.sh
component_name=catalogue
echo Log file output: ${log_file} 

echo -e "${hs} Install Golang and mysql client ${he}" | tee -a ${log_file}

dnf install -y golang git mysql8.4 &>>${log_file}
echo $?
echo -e "${hs} Copy Service to systemd ${he}" | tee -a ${log_file}

cp -r ${component_name}.service /etc/systemd/system/${component_name}.service &>>${log_file}
echo $?
rm -rf /app &>>${log_file}
rm -rf /tmp/${component_name}.zip &>>${log_file}

echo -e "${hs} Stopping service and Deleting exisitin appuser ${he}" | tee -a ${log_file}
systemctl stop ${component_name} &>>${log_file}
systemctl disable ${component_name} &>>${log_file}
userdel -r appuser &>>${log_file}
echo $?

echo -e "${hs} Download App code ${he}" | tee -a ${log_file}

curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>${log_file}
echo $?
echo -e "${hs} Create App Directory ${he}" | tee -a ${log_file}
mkdir -p /app && cd /app &>>${log_file}
echo $?

echo -e "${hs} Extract App code ${he}" | tee -a ${log_file}

unzip /tmp/${component_name}.zip &>>${log_file}
echo $?

echo -e "${hs} Load Schema, App user, Master Data ${he}" | tee -a ${log_file}
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 < db/schema.sql &>>${log_file}
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 < db/app-user.sql &>>${log_file}
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 ${component_name} < db/master-data.sql &>>${log_file}
echo $?

echo -e "${hs} Create Application User ${he}" | tee -a ${log_file}

useradd -r -s /bin/false appuser &>>${log_file}
echo $?

echo -e "${hs} Download App Dependencies ${he}" | tee -a ${log_file}

go mod tidy &>>${log_file}
CGO_ENABLED=0 go build -o /app/${component_name} . &>>${log_file}
echo $?

echo -e "${hs} Grant Permissions and Privilege ${he}" | tee -a ${log_file}
chown -R appuser:appuser /app &>>${log_file}
chmod o-rwx /app -R &>>${log_file}
echo $?

echo -e "${hs} Start Catalogue service ${he}" | tee -a ${log_file}

systemctl daemon-reload &>>${log_file}
systemctl enable ${component_name} &>>${log_file}
systemctl start ${component_name} &>>${log_file}
echo $? 