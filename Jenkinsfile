pipeline {
  agent {
    kubernetes {
      yaml '''
kind: Pod
metadata:
  name: helm
spec:
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
export HELM_EXPERIMENTAL_OCI=1          

NAME=helm-web
VERSION=`yq read Chart.yaml -j | jq -r .version`
FULLVERSIONNAME=$REGISTRY/$NAME:$VERSION
FULLLATESTNAME=$REGISTRY/$NAME:latest

helm chart save . "$FULLVERSIONNAME"
helm chart save . "$FULLLATESTNAME"

helm chart push "$FULLVERSIONNAME"
helm chart push "$FULLLATESTNAME"
          '''
        }        
      }
    }
  }
  parameters {
    string(defaultValue: 'registry.crazyzone.be', name: 'REGISTRY', trim: true)
  }  
}