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

    stage('Deploy Artifact To Nexus') {
      steps {
        script {
          pom = readMavenPom file: "pom.xml";

          filesByGlob = findFiles(glob: "target/*.${pom.packaging}");

          echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"

          artifactPath = filesByGlob[0].path;

          artifactExists = fileExists artifactPath;
          echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
          if (artifactExists) {
            nexusArtifactUploader(
              nexusVersion: 'nexus3',
              protocol: 'http',
              nexusUrl: 'localhost:8081',
              groupId: 'tn.devops',
              version: 'pom.0.0.1-SNAPSHOT',
              repository: 'Emeraude-central-repository',
              credentialsId: 'NEXUS_CRED',
              artifacts: [

                [artifactId: 'pom.demo',
                classifier: '',
                file: artifactPath,
                type: pom.packaging
              ],
              // Lets upload the pom.xml file for additional information for Transitive dependencies
              [artifactId: pom.artifactId,
              classifier: '',
              file: "pom.xml",
              type: "pom"
            ]
          ]
        )
      } else {
        error "*** File: ${artifactPath}, could not be found";
      }
    }

  }
}

}
environment {
SONARQUBE_URL = 'http://192.168.1.17'
SONARQUBE_PORT = '9000'
}
}
