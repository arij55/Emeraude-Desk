pipeline {
  agent any
  stages {
    stage('SCM') {
      steps {
        sh '''pipeline {
 agent any
 stages {
  stage(\'SCM\') {
   steps {
    checkout scm
   }
  }
}
}
'''
        }
      }

    }
  }