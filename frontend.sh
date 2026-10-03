dnf install -y nginx

cp -r nginx.conf /etc/nginx.nginx.conf

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs

curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/frontend.zip
mkdir -p frontend && cd frontend
unzip /tmp/frontend.zip
npm install
npm run build
rm -rf /usr/share/nginx/html/*
cp -r out/* /usr/share/nginx/html/

systemctl enable nginx
systemctl restart nginx