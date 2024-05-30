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
            steps {
                echo 'Deploying to k8s'
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey2',
                                                   keyFileVariable: 'mykey',
                                                   usernameVariable: 'myuser')]) {

                    sh "ssh vagrant@192.168.105.4 -i ${mykey} \"kubectl delete pod myapp --ignore-not-found\""
                    sh "ssh vagrant@192.168.105.4 -i ${mykey} \"kubectl run myapp --image=ttl.sh/fvaldes-docker-ruby-hw\""

                    sh "scp -o StrictHostKeychecking=no -i ${mykey} myapp.yaml ${myuser}@192.168.105.4:"

                    sh "ssh vagrant@192.168.105.4 -i ${mykey} \"kubectl apply -f myapp.yaml\""

                    sh "ssh vagrant@192.168.105.4 -i ${mykey} \"kubectl delete deployments myapp --ignore-not-found\""
                    sh "ssh vagrant@192.168.105.4 -i ${mykey} \"kubectl create deployment myapp --image=ttl.sh/fvaldes-docker-ruby-hw\""
                    sh "ssh vagrant@192.168.105.4 -i ${mykey} \"kubectl scale --replicas=2 deployment/myapp\""
                }
            }
        }
    }
}