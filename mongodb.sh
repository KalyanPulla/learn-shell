cp -r mongodb.repo /etc/yum.repos.d/mongodb-org-7.0.repo

dnf install -y mongodb-org

sed -i 's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' /etc/mongod.conf

systemctl enable mongod

systemctl restart mongod