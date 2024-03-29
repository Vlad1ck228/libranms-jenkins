pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS = 'e687585e-7ca7-4aa7-8ece-06ea814bd55f' 
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
