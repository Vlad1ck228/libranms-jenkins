pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('librenms/librenms:latest')
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.example.com', 'vladhl') {
                        docker.image('your_image_name:latest').push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
    }
}
