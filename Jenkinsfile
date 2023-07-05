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
              reuseNode true
              args '-v/root/.m2/repository:/root/.m2/repository'
              image 'huangzp88/maven-openjdk17'
            }

          }
          steps {
            sh '''
mvn clean compile'''
          }
        }

        stage('CheckStyle') {
          agent {
            docker {
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
              image 'huangzp88/maven-openjdk17'
            }

          }
          steps {
            sh ' mvn checkstyle:checkstyle'
            step([$class: 'CheckStylePublisher',
                   //canRunOnFailed: true,
                   defaultEncoding: '',
                   healthy: '100',
                   pattern: '**/target/checkstyle-result.xml',
                   unHealthy: '90',
                   //useStableBuildAsReference: true
                  ])
          }
        }

      }
    }

    stage('Unit Tests') {
      agent {
        docker {
          image 'huangzp88/maven-openjdk17'
          reuseNode true
          args '-v/root/.m2/repository:/root/.m2/repository'
        }

      }
      when {
        anyOf {
          branch 'master'
        }

      }
      post {
        always {
          junit 'target/surefire-reports/**/*.xml'
        }

      }
      steps {
        sh 'mvn test'
      }
    }

  }
  options {
    skipDefaultCheckout()
  }
}