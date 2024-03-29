pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("librenms/librenms:latest")
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'vladhl') {
                        docker.image("librenms/librenms:latest").push()
                    }
                }
            }
        }
    }
}
