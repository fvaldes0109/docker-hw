pipeline {
    agent any

    stages {
        stage('Build and Push') {
            steps {
                echo 'Building and pushing docker image'
                sh 'docker build -t ttl.sh/fvaldes-docker-ruby-hw .'
                sh 'docker push ttl.sh/fvaldes-docker-ruby-hw'
            }
        }

        stage('Deploy to Target') {
            steps {
                echo 'Deploying to target'
                sh 'docker run -p 4444:4444 ttl.sh/fvaldes-docker-ruby-hw'
            }
        } 
    }
}