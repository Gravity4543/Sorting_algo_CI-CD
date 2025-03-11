pipeline {
    agent any
    tools {
        terraform 'terraform' // Use the Terraform tool configured in Jenkins
    }

    environment {
        // Define variables for username and server IP
        SSH_USER = 'ubuntu'          // Replace with your SSH username
        DOCKER_HUB_REPO = 'dockshikhar/webserver' // Replace with your Docker Hub repo
        DOCKER_HUB_CREDENTIALS = 'dokerid'
    }

    stages {
        stage('Terraform Apply') {
            steps {
                dir('') { // Change to the directory containing your Terraform files
                    sh """
                        # Initialize Terraform
                        terraform init
                        #planning terraform
			terraform plan
                        # Apply Terraform configuration
                        terraform apply --auto-approve

                    """
                    script {
                        // Store the public IP in an environment variable for later stages
                        env.SERVER_IP = sh(script: 'terraform output -raw public_ip', returnStdout: true).trim()
                        echo "Server Public IP: ${env.SERVER_IP}"
                    }
                }
            }
        }

        stage('Wait for Server Readiness') {
            steps {
                script {
                    retryCount = 0
                    maxRetries = 30  // 30 attempts * 20s = 10min timeout
                    ready = false

                    while (retryCount < maxRetries && !ready) {
                        try {
                            sshagent(['3fb305d6-575d-4463-9284-a1597e54c692']) {
                                // Check if the flag file exists
                                sh """
                                    ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SERVER_IP} \
                                        "test -f /tmp/provisioned.ok && echo 'Server ready'"
                                """
                                ready = true
                            }
                        } catch (err) {
                            echo "Server not ready yet (attempt ${retryCount}/${maxRetries}). Retrying in 20s..."
                            sleep(20)
                            retryCount++
                        }
                    }

                    if (!ready) {
                        error("Server provisioning timed out after ${maxRetries} attempts.")
                    }
                }
            }
        }
        stage('Check Docker') {
            steps {
                script {
                    sh 'docker --version'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                dir('project') {
                    script {
                        // Build the Docker image with a tag for the build number
                        docker.build("${DOCKER_HUB_REPO}:${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Authenticate with Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS}") {
                        // Push the Docker image
                        docker.image("${DOCKER_HUB_REPO}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
        stage('Delete Local Docker Image') {
                steps {
                    script {
                        // Delete the locally built Docker image
                        sh "docker rmi ${DOCKER_HUB_REPO}:web_${env.BUILD_NUMBER}"
                    }
                }
            }
        }
    }
    
    post {
    always {
        dir('terraform') {
            sh """
                echo "destroying the terraform module"
                # Destroy Terraform resources to clean up
                terraform destroy -auto-approve
            """
            }
        }
    }
}

