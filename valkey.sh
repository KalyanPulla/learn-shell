source common.sh
echo Log file output: ${log_file}

echo -e "${hs} Install Valkey ${he}" | tee -a ${log_file}
dnf install -y valkey &>>${log_file}
status_check

echo -e "${hs} Change BindIP and set protected mode ${he}" | tee -a ${log_file}
sudo sed -i 's/^bind .*/bind 0.0.0.0/' /etc/valkey/valkey.conf &>>${log_file}
sudo sed -i 's/^protected-mode .*/protected-mode no/' /etc/valkey/valkey.conf &>>${log_file}
status_check

echo -e "${hs} Restart Valkey ${he}" | tee -a ${log_file}
systemctl enable valkey &>>${log_file}
systemctl restart valkey &>>${log_file}
status_check
