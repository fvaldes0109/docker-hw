pipeline {
    agent any

    tools {
        nodejs 'nodejs-22'
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                echo 'Building and pushing docker image'
                sh 'docker build -t ttl.sh/fvaldes-docker-ruby-hw .'
                sh 'docker push ttl.sh/fvaldes-docker-ruby-hw'
            }
        }

        stage('Deploy to Stage (Target)') {
            steps {
                echo 'Deploying to target'
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey2',
                                                   keyFileVariable: 'mykey',
                                                   usernameVariable: 'myuser')]) {
                    
                    script {
                        // Check if there are any running containers
                        def runningContainers = sh(script: "ssh vagrant@192.168.105.3 -i ${mykey} \"docker ps -aq\"", returnStdout: true).trim()
                        
                        if (runningContainers) {
                            // Stop and remove all containers if there are any running
                            sh "ssh vagrant@192.168.105.3 -i ${mykey} \"docker ps -aq | xargs docker stop | xargs docker rm\""
                            echo "Stopped and removed all running containers."
                        } else {
                            echo "No running containers to stop and remove."
                        }
                    }
                    
                    sh "ssh vagrant@192.168.105.3 -i ${mykey} \"docker run -d -p 4444:4444 ttl.sh/fvaldes-docker-ruby-hw\""
                }
            }
        }

        stage('Test Stage (Target)') {
            steps {
                echo 'Testing'
                sh 'newman run test.json --enviroment stage.json'
            }
        }

        stage('Deploy to Production (AWS)') {
            steps {
                echo 'Deploying to AWS'
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey2aws',
                                                   keyFileVariable: 'mykey',
                                                   usernameVariable: 'myuser')]) {
                    
                    script {
                        // Check if there are any running containers
                        def runningContainers = sh(script: "ssh ubuntu@51.21.1.133 -i ${mykey} \"docker ps -aq\"", returnStdout: true).trim()
                        
                        if (runningContainers) {
                            echo "Running containers: ${runningContainers}"
                            // Stop and remove all containers if there are any running
                            sh "ssh ubuntu@51.21.1.133 -i ${mykey} \"docker ps -aq | xargs docker stop | xargs docker rm\""
                            echo "Stopped and removed all running containers."
                        } else {
                            echo "No running containers to stop and remove."
                        }
                    }
                    
                    sh "ssh ubuntu@51.21.1.133 -i ${mykey} \"docker run -d -p 4444:4444 ttl.sh/fvaldes-docker-ruby-hw\""
                }
            }
        }

        stage('Test Production (AWS)') {
            steps {
                echo 'Testing'
                sh 'newman run test.json --enviroment production.json'
            }
        } 
    }
}