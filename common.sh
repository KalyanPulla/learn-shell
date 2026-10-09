log_file=/tmp/roboshop.log
hs="\e[32m >>>>>>>>>>"
he="<<<<<<<<<< \e[0m"

app_prereq() {
    echo -e "${hs} Copy Service to systemd ${he}" | tee -a ${log_file}
    cp -r ${component_name}.service /etc/systemd/system/${component_name}.service &>>${log_file}
    status_check

    echo -e "${hs} Remove Existing files when rerun ${he}" | tee -a ${log_file}
    rm -rf /app &>>${log_file}
    rm -rf /tmp/${component_name}.zip &>>${log_file}

    echo -e "${hs} Create Application User ${he}" | tee -a ${log_file}
    useradd -r -s /bin/false appuser &>>${log_file}
    status_check

    echo -e "${hs} Download App code ${he}" | tee -a ${log_file}
    curl -L -o /tmp/${component_name}.zip https://raw.githubusercontent.com/raghudevopsb89/roboshop-microservices/main/artifacts/${component_name}.zip &>>${log_file}
    status_check

    echo -e "${hs} Create App Directory ${he}" | tee -a ${log_file}
    mkdir -p /app && cd /app &>>${log_file}
    status_check

    echo -e "${hs} Extract App code ${he}" | tee -a ${log_file}
    unzip /tmp/${component_name}.zip &>>${log_file}
    status_check
}

systemd_service() {
    echo -e "${hs} Grant Permissions and Privileges ${he}" | tee -a ${log_file}
    chown -R app${component_name}:app${component_name} /app &>>${log_file}
    chmod o-rwx /app -R &>>${log_file}
    status_check

    echo -e "${hs} Start User service ${he}" | tee -a ${log_file}
    systemctl daemon-reload &>>${log_file}
    systemctl enable ${component_name} &>>${log_file}
    systemctl start ${component_name} &>>${log_file}
    status_check
}

golang_app() {
    app_prereq
    dnf install -y golang git &>>${log_file}
    status_check

    echo -e "${hs} Download App Dependencies ${he}" | tee -a ${log_file}
    go mod tidy &>>${log_file}
    CGO_ENABLED=0 go build -o /app/${component_name} . &>>${log_file}
    status_check
    systemd_service
}

nodejs_app() {
    app_prereq
    echo -e "${hs} Download and Install Nodejs ${he}" | tee -a ${log_file}
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - &>>${log_file}
    dnf install -y nodejs &>>${log_file}
    status_check
    echo -e "${hs} Install dependencies for nodejs ${he}" | tee -a ${log_file} 
    npm install --production &>>${log_file}
    status_check 
    systemd_service
}

status_check() {
    if [$? -eq 0]; then
        echo -e "\e[32m SUCCESS \e[0m"
    else
        echo -e "\e[31m FAILURE \e[0m"
}

java_app() {
    app_prereq
    echo -e "${hs} Install Java Maven ${he}" | tee -a ${log_file}
    dnf install -y java-21-openjdk java-21-openjdk-devel maven &>>${log_file}
    status_check

    echo -e "${hs} Complile Package into build ${he}" | tee -a ${log_file}
    mvn clean package -DskipTests &>>${log_file}
    status_check

    echo -e "${hs} Copy JAR code to Application Folder ${he}" | tee -a ${log_file}
    cp target/${component_name}.jar /app/${component_name}.jar &>>${log_file}
    status_check

    systemd_service
}

python_app() {
    app_prereq

    echo -e "${hs} Install Python and pip ${he}" | tee -a ${log_file}
    dnf install -y python3 python3-pip &>>${log_file}
    status_check

    echo -e "${hs} Install requirements ${he}" | tee -a ${log_file}
    pip3 install -r requirements.txt &>>${log_file}
    status_check

    systemd_service
}

schema_load() {
    if ["$schema_load" = "true"]; then
        if ["$schema_type" = "true"]; then            
            echo -e "${hs} Install Golang and mysql client ${he}" | tee -a ${log_file}
            dnf install mysql8.4 &>>${log_file}
            status_check

            echo -e "${hs} Load Schema, App user, Master Data ${he}" | tee -a ${log_file}
            for file in $schema_files; do
                mysql -h mysql-dev.kaldevops14.online -u root -pRoboShop@1 < db/${file} &>>${log_file}
            done
            status_check
        fi
    fi
}