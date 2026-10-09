source common.sh
component_name=ratings
echo Log file Output : ${log_file}

dnf install -y mysql8.4
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 < db/schema.sql
mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 < db/app-user.sql
python_app