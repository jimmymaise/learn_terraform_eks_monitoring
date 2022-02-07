#! /bin/bash
sudo yum update && sudo yum install python3-pip
python3 -m pip install -U pip
pip install jenkins-job-builder
mkdir /etc/jenkins_jobs
vim /etc/jenkins_jobs/jenkins_jobs.ini
