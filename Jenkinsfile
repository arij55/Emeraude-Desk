pipeline {
  agent any
  stages {
    stage('SCM') {
      steps {
        checkout scm
      }
    }

    stage('Compile') {
      agent {
        docker {
          args '-v /root/.m2/repository:/root/.m2/repository'
          reuseNode true
          image 'huangzp88/maven-openjdk17:latest'
        }

      }
      steps {
        sh '''
mvn clean compile'''
      }
    }

  }
}