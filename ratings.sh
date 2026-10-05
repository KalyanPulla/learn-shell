dnf install -y python3 python3-pip mysql8.4

cp -r ratings.service /etc/systemd/system/ratings.service

rm -rf /app

curl -L -o /tmp/ratings.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/ratings.zip
mkdir -p /app && cd /app
unzip /tmp/ratings.zip
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/schema.sql
mysql -h <MYSQL-SERVER-IP> -u root -pRoboShop@1 < db/app-user.sql

useradd -r -s /bin/false appuser
mkdir -p /app
pip3 install -r /app/requirements.txt cryptography
chown -R appuser:appuser /app
chmod o-rwx /app -R

systemctl daemon-reload
systemctl enable ratings
systemctl start ratings