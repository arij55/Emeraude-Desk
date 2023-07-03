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
              image 'simaofsilva/maven-openjdk11-alpine:latest'
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
            }

          }
          steps {
            sh 'mvn clean compile'
          }
        }

        stage('CheckStyle') {
          agent {
            docker {
              image 'simaofsilva/maven-openjdk11-alpine:latest'
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
            }

          }
          steps {
            sh ' mvn checkstyle:checkstyle'
           step([$class: 'CheckStylePublisher',
              
                 pattern: '**/target/checkstyle-result.xml',
                ])                
          }
        }

      }
    }

  }
}
