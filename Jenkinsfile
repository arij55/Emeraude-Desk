pipeline {
  agent any
  stages {
    stage('SCM') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      parallel {
        stage('Compile') {
          agent {
            docker {
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
              image 'maven:3.6.0-jdk-8-alpine'
            }

          }
          steps {
            sh 'mvn clean compile'
          }
        }

        stage('CheckStyle') {
          agent {
            docker {
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
              image 'maven:3.6.0-jdk-8-alpine'
            }

          }
          steps {
            sh ' mvn checkstyle:checkstyle'
          }
        }

      }
    }

  }
}