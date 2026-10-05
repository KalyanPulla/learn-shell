cp -r rabbitmq_erlang.repo /etc/yum.repos.d/rabbitmq_erlang.repo
dnf install -y erlang
cp -r rabbitmq_rabbitmq-server.repo /etc/yum.repos.d/rabbitmq_rabbitmq-server.repo
dnf install -y rabbitmq-server

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

rabbitmqctl add_user roboshop RoboShop@1
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

#optional
# rabbitmq-plugins enable rabbitmq_management
# systemctl restart rabbitmq-server

