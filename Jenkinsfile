pipeline {
  agent {
    kubernetes {
      yaml '''
kind: Pod
metadata:
  name: helm
spec:
  serviceAccountName: jenkins
  containers:
  - name: helm
    image: registry.crazyzone.be/helm:latest
    imagePullPolicy: Always
    command:
    - sleep
    - infinity
'''
    }

  }
  stages {
    stage('build') {
      steps {
        container(name: 'helm') {
          sh '''#!/bin/sh 
/build.sh push
          '''
        }
      }
    }
    stage('helm-upgrade') {
      when { 
          branch 'autoupdate'
      }
      steps {
        container(name: 'helm') {
          sh '''#!/bin/sh 
/build.sh upgrade home
          '''
        }
      }
    }
  }
}
