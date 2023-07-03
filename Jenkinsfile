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
              image 'huangzp88/maven-openjdk17:latest'
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
              image 'huangzp88/maven-openjdk17:latest'
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
            }

          }
          steps {
            sh ' mvn checkstyle:checkstyle'
            sh '''class: \'CheckStylePublisher\',
                           canRunOnFailed: true,
                           defaultEncoding: \'\',
                           healthy: \'100\',
                           pattern: \'**/target/checkstyle-result.xml\',
                           unHealthy: \'90\',
                           useStableBuildAsReference: true'''
          }
        }

      }
    }

  }
}