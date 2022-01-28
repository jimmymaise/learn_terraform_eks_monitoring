pipeline {
  agent any
  environment {
        AWS_ACCESS_KEY = credentials('JENKINS_AWS_ACCESS_KEY')
        AWS_SECRET_KEY = credentials('JENKINS_AWS_SECRET_KEY')
        TERRAFORM_HOME = "/usr/local/bin/"
        TF_IN_AUTOMATION = 'true'
        ENV="dev"
        PATH="$PATH:~/usr/local/bin/"
  }
  stages {

      stage('Unit test') {
        steps {
          sh "go mod download"
          sh "go test ./terra_test/... -v"
        }
      }
    stage('Terraform Init') {
      steps {
        echo env.AWS_ACCESS_KEY
        echo env.AWS_SECRET_KEY
        sh "cd eks-with-monitoring"
        sh "ls -lha"
        sh "${env.TERRAFORM_HOME}/terraform -chdir=\"./eks-with-monitoring\" init -backend-config=envs/${env.ENV}/backend.conf"
      }
    }
    stage('Terraform Plan') {
      steps {
        sh "${env.TERRAFORM_HOME}/terraform -chdir=\"./eks-with-monitoring\" plan -var-file=envs/${ENV}/terraform.tfvars -out=terra.plan"
      }
    }
    stage('Terraform Apply') {
      steps {
        sh "${env.TERRAFORM_HOME}/terraform -chdir=\"./eks-with-monitoring\" apply terra.plan --auto-approve"
      }
    }
  }
}