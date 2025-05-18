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
        // Path to kubeconfig copied from remote K8s VM
        KUBECONFIG = "${WORKSPACE}/.kube/config" 
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
        
        
        stage('Push images to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker_hub_creds', url: '']) {
                    sh 'docker push $BACKEND_IMAGE:latest'
                    sh 'docker push $FRONTEND_IMAGE:latest'
                    sh 'docker push $MIGRATE_IMAGE:latest'
                }
            }
        }

        stage('Déploiement sur Kubernetes avec terraform') {
            steps {
                script{
                    sh 'mkdir -p ${WORKSPACE}/.kube'
                    // 1. Copy kubeconfig securely (from Jenkins credentials)
                    withCredentials([file(credentialsId: 'k8s-kubeconfig', variable: 'KUBECONFIG')]) {
                        sh '''
                            cp $KUBECONFIG ~/.kube/config
                            chmod 600 ~/.kube/config
                        '''
                    }
                    // 2. Initialize & apply Terraform
                    dir('terraform') {
                        sh '''
                        terraform init
                        terraform apply -auto-approve
                        '''
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
