#!/bin/bash

# Update all packages
yum update -y
dnf update -y

curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -

dnf install nodejs -y

yum install git -y

git clone https://github.com/sandeshlama7/sample_todo.git

cd sample_todo
npm install

echo "[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc" > /etc/yum.repos.d/mongodb-org-7.0.repo

yum install -y mongodb-org
systemctl start mongod

node server.js &
