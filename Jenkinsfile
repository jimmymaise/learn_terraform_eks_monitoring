pipeline {
  agent any
//   parameters {
//     password (name: 'AWS_ACCESS_KEY_ID')
//     password (name: 'AWS_SECRET_ACCESS_KEY')
//   }
  environment {
        AWS_ACCESS_KEY = credentials('JENKINS_AWS_ACCESS_KEY')
        AWS_SECRET_KEY = credentials('JENKINS_AWS_SECRET_KEY')
        TERRAFORM_HOME = "/usr/local/bin/"
        TF_IN_AUTOMATION = 'true'
        ENV="dev"
//     AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
//     AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
  }
  stages {
    stage('Terraform Init') {
      steps {
        echo env.AWS_ACCESS_KEY
        echo env.AWS_SECRET_KEY
        sh "cd eks-with-monitoring"
        sh "ls -lha"
        sh "${env.TERRAFORM_HOME}/terraform -chdir=\"./eks-with-monitoring\" init -backend-config=envs/${env.ENV}/backend.conf"
      }
    }
//     stage('Terraform Plan') {
//       steps {
//
//         sh "${env.TERRAFORM_HOME}/terraform -chdir=\"./eks-with-monitoring\" plan -out=tfplan -input=false -var-file='dev.tfvars'"
//       }
//     }
    stage('Terraform Apply') {
      steps {
        sh "${env.TERRAFORM_HOME}/terraform -chdir=\"./eks-with-monitoring\" apply -backend-config=envs/${env.ENV}/backend.conf -input=false"
      }
    }
    stage('AWSpec Tests') {
      steps {
          sh '''#!/bin/bash -l
bundle install --path ~/.gem
bundle exec rake spec || true
'''

        junit(allowEmptyResults: true, testResults: '**/testResults/*.xml')
      }
    }
  }
}