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
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
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

        /*stage('Expose minikube for jenkins') {
            steps {
                ansiblePlaybook(
                    inventory: 'ansible/inventory.ini',
                    playbook: 'ansible/expose_minikube_api.yml'
                )
            }
        }*/

        stage('Déploiement sur Kubernetes avec terraform') {
            steps {
                sshagent(['minikube-ssh-key']) {
                    dir('terraform') {
                        sh '''
                        terraform init
                        terraform apply -auto-approve -var="minikube_ip=${MINIKUBE_IP}"
                        '''
                    }
                }
            }
        }

        stage('Postgres DB migration') {
            steps {
                ansiblePlaybook(
                    inventory: 'ansible/inventory.ini',
                    playbook: 'ansible/django-migration-job.yml'
                )
            }
        }

        stage('Expose backend service for Prometheus') {
            steps {
                ansiblePlaybook(
                    inventory: 'ansible/inventory.ini',
                    playbook: 'ansible/expose_backend_for_prometheus.yml'
                )
            }
        }

        stage('Monitoring with Prometheus with ansible') {
            steps {
                ansiblePlaybook(
                    inventory: 'ansible/inventory.ini',
                    playbook: 'prometheus/playbook.yml'
                )
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
