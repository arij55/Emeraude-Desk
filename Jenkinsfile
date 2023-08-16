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
            sh '''$class: \'CheckStylePublisher\'               
                            
                             
 '''
            findBuildScans()
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

    stage('Integration Tests') {
      agent {
        docker {
          image 'huangzp88/maven-openjdk17'
          args '-v /root/.m2/repository:/root/.m2/repository'
        }

      }
      post {
        always {
          junit 'target/failsafe-reports/**/*.xml'
        }

        success {
          stash(name: 'artifact', includes: 'target/*.war')
          stash(name: 'pom', includes: 'pom.xml')
          archiveArtifacts 'target/*.war'
        }

      }
      steps {
        sh 'mvn verify '
      }
    }

    stage('Code Quality Analysis') {
      post {
        always {
          recordIssues(aggregatingResults: true, tools: [javaDoc(), checkStyle(pattern: '**/target/checkstyle-result.xml'), findBugs(pattern: '**/target/findbugsXml.xml', useRankAsPriority: true), pmdParser(pattern: '**/target/pmd.xml')])
        }

      }
      parallel {
        stage('PMD') {
          agent {
            docker {
              image 'huangzp88/maven-openjdk17'
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
            }

          }
          steps {
            sh ''' mvn pmd:pmd
$class: \'PmdPublisher\''''
          }
        }

        stage('Findbugs') {
          agent {
            docker {
              image 'huangzp88/maven-openjdk17'
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
            }

          }
          steps {
            sh ''' mvn findbugs:findbugs
$class: \'PmdPublisher\''''
          }
        }

        stage('JavaDoc') {
          agent {
            docker {
              image 'huangzp88/maven-openjdk17'
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
            }

          }
          steps {
            sh ' mvn javadoc:javadoc'
            step([$class: 'JavadocArchiver', javadocDir: './target/site/apidocs', keepAll: 'true'])
          }
        }

      }
    }

  }
}