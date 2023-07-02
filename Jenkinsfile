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
          image 'huangzp88/maven-openjdk17:latest'
          args '-v /root/.m2/repository:/root/.m2/repository'
          reuseNode true  
       }
      }
      steps {
        sh 'mvn clean compile'
      }
    }

  }
}
