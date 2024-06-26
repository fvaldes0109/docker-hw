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

        stage('Deploy to Target') {
            steps {
                echo 'Deploying to target'
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey2',
                                                   keyFileVariable: 'mykey',
                                                   usernameVariable: 'myuser')]) {
                    
                    script {
                        // Check if there are any running containers
                        def runningContainers = sh(script: 'docker ps -aq', returnStdout: true).trim()
                        
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

        stage('Test Target') {
            steps {
                echo 'Testing'
                sh 'newman run test.json'
            }
        }

        stage('Deploy to k8s') {
            environment {
                ANSIBLE_HOST_KEY_CHECKING = 'false'
            }
            steps {
                sh 'echo "Deploying to k8s..."'
                ansiblePlaybook credentialsId: 'mykey2',
                                inventory: 'host.ini',
                                playbook: 'playbook.yml'
            }
        }
    }
}