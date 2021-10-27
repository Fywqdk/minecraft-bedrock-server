pipeline {
  environment {
    imageName = "minecraft-bedrock-server"
    dockerhubRegistry = "iceoid/+ $imageName"
    githubRegistry = "ghcr.io/iceoid/$imageName"
    dockerhubCredentials = 'DOCKERHUB_TOKEN'
    githubCredentials = 'GITHUB_TOKEN'
    
    dockerhubImage = ''
    dockerhubImageLatest = ''
    githubImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git branch: 'main', credentialsId: 'GITHUB_TOKEN', url: 'https://github.com/Iceoid/minecraft-bedrock-server.git'
      }
    }
    stage('Building image') {
      steps{
        script {
//           dockerhubImage = docker.build dockerhubRegistry + ":$BUILD_NUMBER"
          dockerhubImageLatest = docker.build dockerhubRegistry + ":latest"
          
          githubImage = docker.build githubRegistry + ":latest"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', dockerhubCredentials ) {
            dockerhubImage.push()
            dockerhubImageLatest.push()
          }
          docker.withRegistry('https://' + githubRegistry, githubCredentials) {
            githubImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
//         sh "docker rmi $dockerhubRegistry$imageName:$BUILD_NUMBER"
        sh "docker rmi $dockerhubRegistry$imageName:latest"
        sh "docker rmi $githubRegistry$imageName:latest"
      }
    }
  }
}
