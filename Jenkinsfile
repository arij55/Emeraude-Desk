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
              image 'maven:3.6.0-jdk-8-alpine'
              args '-v /root/.m2/repository:/root/.m2/repository'
              reuseNode true
            }

          }
          steps {
            sh ' mvn javadoc:javadoc'
            step([$class: 'JavadocArchiver', javadocDir: './target/site/apidocs', keepAll: 'true'])
          }
        }

        stage('SonarQube') {
          agent {
            docker {
              image 'maven:3.6.0-jdk-8-alpine'
              reuseNode true
            }

          }
          steps {
            sh " mvn sonar:sonar -Dsonar.host.url=$SONARQUBE_URL:$SONARQUBE_PORT"
          }
        }

      }
    }
/*
    stage('Deploy Artifact To Nexus') {
      when {
        anyOf {
          branch 'master'
          branch 'develop'
        }

      }
      steps {
        script {
          unstash 'pom'
          unstash 'artifact'
          // Read POM xml file using 'readMavenPom' step , this step 'readMavenPom' is included in: https://plugins.jenkins.io/pipeline-utility-steps
          pom = readMavenPom file: "pom.xml";
          artifactPath = filesByGlob[0].path;
          nexusArtifactUploader(
            nexusVersion: NEXUS_VERSION,
            protocol: NEXUS_PROTOCOL,
            nexusUrl: NEXUS_URL,
            groupId: pom.groupId,
            version: pom.version,
            repository: NEXUS_REPOSITORY,
            credentialsId: NEXUS_CREDENTIAL_ID,

          )
        }

  

  
    */
  } } 
    environment {
    NEXUS_VERSION = 'nexus3'
    NEXUS_URL = 'nexus:8081'
    NEXUS_PROTOCOL = 'http'
    NEXUS_REPOSITORY = 'maven-snapshots'
    NEXUS_CREDENTIAL_ID = 'Emeraude-Desk'
    SONARQUBE_URL = 'http://192.168.1.17'
    SONARQUBE_PORT = '9000'
  }
}
}
