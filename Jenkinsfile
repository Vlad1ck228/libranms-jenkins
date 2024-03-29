pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS = 'vladhl' 
        IMAGE_NAME = 'vladhl/mylibrenms:latest' 
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(IMAGE_NAME)
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS) {
                        docker.image(IMAGE_NAME).push()
                    }
                }
            }
        }
    }
}
