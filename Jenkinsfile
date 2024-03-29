pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = "vladhl"
        IMAGE_NAME = "mylibra"
        IMAGE_TAG = "latest"
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}", "-f /home/ubuntu/libranms/Dockerfile .")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'your-docker-credentials') {
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
    }
}
