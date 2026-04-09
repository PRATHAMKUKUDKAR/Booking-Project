pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select action')
    }

    stages {

        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/PRATHAMKUKUDKAR/Terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-cred'
                ]]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-cred'
                ]]) {
                    sh 'terraform plan'
                }
            }
        }

        stage('Apply or Destroy') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-cred'
                ]]) {
                    script {
                        if (params.ACTION == 'apply') {
                            sh 'terraform apply -auto-approve'
                        } else {
                            sh 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }

    }
}
