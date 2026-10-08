echo -e '\e[31m Hello World\e[0m'
component_name=frontend 

echo -e '\e[31m >>>>>>>>>> Install Nginx <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

dnf install -y nginx &>>/tmp/roboshop.log
echo $?
echo -e '\e[31m >>>>>>>>>> Copy Nginx Config <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

cp nginx.conf /etc/nginx/nginx.conf &>>/tmp/roboshop.log
echo $?
echo -e '\e[31m >>>>>>>>>> Install Nodejs <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>/tmp/roboshop.log
echo $?
dnf install -y nodejs &>>/tmp/roboshop.log
echo $?
echo -e '\e[31m >>>>>>>>>> Create App Directory <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

rm -rf component_name &>>/tmp/roboshop.log
mkdir -p component_name && cd component_name &>>/tmp/roboshop.log
echo $?
rm -rf /tmp/component_name.zip &>>/tmp/roboshop.log

echo -e '\e[31m >>>>>>>>>> Download Frontend Code <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

curl -L -o /tmp/component_name.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/component_name.zip &>>/tmp/roboshop.log
echo $?
echo -e '\e[31m >>>>>>>>>> Extract App Code <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

unzip /tmp/component_name.zip &>>/tmp/roboshop.log
echo $?
echo -e '\e[31m >>>>>>>>>> Install and Run Build Files <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

npm cache clean --force &>>/tmp/roboshop.log
npm install &>>/tmp/roboshop.log
npm run build &>>/tmp/roboshop.log
echo $?
echo -e '\e[31m >>>>>>>>>> Copy Build code to Nginx <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
cp -r out/* /usr/share/nginx/html/ &>>/tmp/roboshop.log
echo $?
echo -e '\e[31m >>>>>>>>>> Restart Nginx <<<<<<<<<<\e[0m' | tee -a /tmp/roboshop.log

systemctl enable nginx &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log
echo $?