pipeline {
    agent any

    tools {
        terraform 'terraform'  // Must match tool name in Jenkins
    }
    
    environment {
        DOCKER_USER = 'marieme21'
        BACKEND_IMAGE = "${DOCKER_USER}/projetfilrouge_backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/projetfilrouge_frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/projetfilrouge_migrate"
        // Set your Minikube host IP manually
        MINIKUBE_IP = "192.168.142.129"

    }

    stages {
        stage('Clone') {
            steps {
                git(
                    url: 'https://github.com/marieme21/Jenkins_projects.git',
                    credentialsId: 'git_jenkinsID', // Add this line
                    branch: 'main'
                )
              }
        }
 
        stage('Build') {
            steps {
                sh 'docker build -t $BACKEND_IMAGE:latest ./Backend/odc'
                sh 'docker build -t $FRONTEND_IMAGE:latest ./Frontend'
                sh 'docker build -t $MIGRATE_IMAGE:latest ./Backend/odc'
            }
        }
        
        
        /*stage('Push images to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker_hub_creds', url: '']) {
                    sh 'docker push $BACKEND_IMAGE:latest'
                    sh 'docker push $FRONTEND_IMAGE:latest'
                    sh 'docker push $MIGRATE_IMAGE:latest'
                }
            }
        }*/

        stage('Déploiement sur Kubernetes avec terraform') {
            steps {
                sshagent(['minikube-ssh-key']) {
                    sh '''
                    # Pre-populate known_hosts
                    ssh-keyscan 192.168.142.129 > ~/.ssh/known_hosts
                    
                    # Test connection
                    ssh marieme@192.168.142.129 "minikube status"
                    '''
                }
                script{
                    
                    // Verify connectivity
                    sh """
                    kubectl config view
                    echo "Testing connection to Minikube..."
                    kubectl config set-cluster minikube-remote --server=http://${MINIKUBE_IP}:8001
                    kubectl config set-context minikube-remote --cluster=minikube-remote --user=minikube
                    kubectl config use-context minikube-remote
                    """
                    
                    // Run Terraform
                    dir('terraform') {
                        sh '''
                        ssh marieme@${MINIKUBE_IP}
                        terraform init
                        '''
                        //terraform apply -auto-approve -var="minikube_ip=${MINIKUBE_IP}"
                    }
                    // 3. Verify deployment
                    sh 'kubectl get pods -o wide'
                }
            }
        }

        /*stage('Déploiement local avec Docker Compose') {
            steps {
                sh 'docker compose down || true'
                sh 'docker compose pull'
                sh 'docker compose up -d --build'
            }
        }*/
    }
    post {
        success {
            mail to: 'mariemedieye21@gmail.com',
                 subject: "✅ Déploiement local réussi",
                 body: "L'application a été déployée localement avec succès."
        }
        failure {
            mail to: 'mariemedieye21@gmail.com',
                 subject: "❌ Échec du pipeline Jenkins",
                 body: "Une erreur s’est produite, merci de vérifier Jenkins."
        }
        always {
        sh 'rm -rf ${WORKSPACE}/.kube'  // Remove kubeconfig
    }
    }
}
