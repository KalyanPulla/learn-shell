source common.sh

echo -e "${hs} Copy Mongo Repo to Repo config ${he}" | tee -a ${log_file}
cp -r mongodb.repo /etc/yum.repos.d/mongodb-org-7.0.repo &>>${log_file}
status_check

echo -e "${hs} Install MongoDB ${he}" | tee -a ${log_file}
dnf install -y mongodb-org &>>${log_file}
status_check

echo -e "${hs} Change Bind IP ${he}" | tee -a ${log_file}
sed -i 's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check

echo -e "${hs} Restart MongoDB ${he}" | tee -a ${log_file}
systemctl enable mongod &>>${log_file}
systemctl restart mongod &>>${log_file}
status_check