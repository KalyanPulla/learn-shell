cp -r rabbitmq_erlang.repo /etc/yum.repos.d/rabbitmq_erlang.repo
cp -r rabbitmq_rabbitmq-server.repo /etc/yum.repo.d/rabbitmq_rabbitmq-server.repo

dnf install -y erlang
dnf install -y rabbitmq-server

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

rabbitmqctl add_user roboshop RoboShop@1
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

#optional
# rabbitmq-plugins enable rabbitmq_management
# systemctl restart rabbitmq-server

