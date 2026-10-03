dnf install -y valkey

sudo sed -i 's/^bind .*/bind 0.0.0.0/' /etc/valkey/valkey.conf
sudo sed -i 's/^protected-mode .*/protected-mode no/' /etc/valkey/valkey.conf

systemctl enable valkey
systemctl restart valkey
