# Learn Terraform EKS Monitoring

This project aims to demonstrate how to set up an Amazon EKS (Elastic Kubernetes Service) cluster, automate deployment processes through Jenkins, and monitor it using Grafana. The project involves several AWS services such as EKS, S3, and IAM, along with Terraform for infrastructure as code, Jenkins for CI/CD (Continuous Integration/Continuous Deployment), and Kubernetes for container orchestration.

:warning: **Note:** This is a pet project and is not intended for production use. Always follow best practices when deploying infrastructure for production environments.

## Table of Contents
- [Technologies](#technologies)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Features](#features)

## Technologies
- AWS EKS
- AWS S3
- AWS IAM
- Terraform
- Kubernetes
- Grafana

## Getting Started

### Prerequisites
- AWS CLI installed and configured
- Terraform installed
- `kubectl` installed

### Steps to Run
1. **Create an AWS S3 bucket in the us-west-2 region**
    ```bash
    aws s3api create-bucket --bucket dev-eks-monitoring-pet-backend --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
    ```
  
2. **Set Environment Variable to `dev`**
    ```bash
    export ENV="dev"
    ```

3. **Initialize Terraform**
    ```bash
    terraform init -backend-config=envs/${ENV}/backend.conf
    ```

4. **Apply Terraform Configuration**
    ```bash
    terraform apply -var-file=envs/${ENV}/terraform.tfvars
    ```

5. **Update `kubeconfig` for EKS Cluster**
    ```bash
    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
    ```

6. **Apply Kubernetes Dashboard and Get Admin Token**
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
    kubectl apply -f ./kubeyaml/dashboard-adminuser.yaml
    ```

7. **Start `kubectl` proxy**
    ```bash
    kubectl proxy
    ```

8. **Get Grafana Load Balancer Hostname**
    ```bash
    export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    echo "http://$ELB"
    ```

9. **Run Load Generators for Testing**
    ```bash
    kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"
    ```

## Usage

After setting up, you can open the Grafana dashboard to monitor the EKS cluster.

## Features
- Infrastructure as Code (IaC) using Terraform
- EKS Cluster Management
- AWS S3 and IAM Configuration
- Grafana Dashboard Setup
- Kubernetes Dashboard Configuration

## License

MIT
