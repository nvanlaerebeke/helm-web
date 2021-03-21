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
sleep infinity
if [[ $GIT_LOCAL_BRANCH == "main" || $GIT_LOCAL_BRANCH == "autoupdate" ]];
then
    VERSION=`yq read Chart.yaml -j | jq -r .version`
    NAME=`yq read Chart.yaml -j | jq -r .name`
    DEPLOYMENT=`helm list -n home -o json -f "$NAME" | jq '.[]'`
    if [ $? -ne 0 ];
    then
        echo "Failed getting deployments"
        exit 1
    fi
    DEPLOYED_VERSION=`echo $DEPLOYMENT | jq -r '.app_version'`
    TARGETNAME=`echo $DEPLOYMENT | jq -r '.name'`
    TARGETNAMESPACE=`echo $DEPLOYMENT | jq -r '.namespace'`
    
    if [ $DEPLOYED_VERSION == $VERSION ];
    then
        helm upgrade --install -n "$TARGETNAMESPACE" "$TARGETNAME" .
        if [ $? -ne 0 ];
        then
            echo "Failed to upgrade helm chart"
            exit 1
        fi
    fi
fi
          '''
        }
      }
    }
  }
}
