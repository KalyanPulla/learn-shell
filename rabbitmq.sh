source common.sh
echo Log file Output : ${log_file}

echo -e "${hs} Copy Erlang Repo to the repo folder ${he}" | tee -a ${log_file}
cp -r erlang.repo /etc/yum.repos.d/rabbitmq_erlang.repo
status_check

echo -e "${hs} Install Erlang ${he}" | tee -a ${log_file}
dnf install -y erlang
status_check

echo -e "${hs} Copy Rabbitmq Server Repo to the repo folder ${he}" | tee -a ${log_file}
cp -r rabbitmq-server.repo /etc/yum.repos.d/rabbitmq_rabbitmq-server.repo
status_check

echo -e "${hs} Install Rabbitmq server ${he}" | tee -a ${log_file}
dnf install -y rabbitmq-server
status_check

echo -e "${hs} Start Rabbitmq server ${he}" | tee -a ${log_file}
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
status_check

echo -e "${hs} Add user and set user tags and permissionsr ${he}" | tee -a ${log_file}
rabbitmqctl add_user roboshop RoboShop@1
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
status_check

#optional
# rabbitmq-plugins enable rabbitmq_management
# systemctl restart rabbitmq-server

