pipeline {
    agent any
    
    environment {
        LIBRENMS_IMAGE = 'librenms/librenms
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Vlad1ck228/libranms-jenkins'
            }
        }
        
        stage('Build Image') {
            steps {
                script {
                    docker.build("${librenms_test}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'vladhl') {
    sh "docker push ${librenms_test}:${env.BUILD_NUMBER}"
                        
                    }
                }
            }
        }
    }
}
