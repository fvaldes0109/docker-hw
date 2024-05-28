pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building... and pushing docker image'
                sh 'docker build -t myapp:latest .'
            }
        }
    }
}