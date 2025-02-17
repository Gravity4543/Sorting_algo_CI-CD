pipeline {
    agent any
    tools {
        terraform 'terraform' // Use the Terraform tool configured in Jenkins
    }

    environment {
        // Define variables for username and server IP
        SSH_USER = 'ubuntu'          // Replace with your SSH username
        GIT_REPO = 'https://github.com/example/example-repo.git' // Replace with your Git repository URL
    }

    stages {
        stage('Terraform Apply') {
            steps {
                dir('') { // Change to the directory containing your Terraform files
                    sh """
                        # Initialize Terraform
                        terraform init

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
