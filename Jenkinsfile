pipeline {
    agent any

    environment {
        DOCKER_USER = 'marieme21'
        BACKEND_IMAGE = "${DOCKER_USER}/projetfilrouge_backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/projetfilrouge_frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/projetfilrouge_migrate"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git(
                    url: 'https://github.com/marieme21/Jenkins_projects.git',
                    credentialsId: 'git_jenkinsID', // Add this line
                    branch: 'main'
                )
              }
        }
        stage('Build des images') {
            steps {
                sh 'docker build -t $BACKEND_IMAGE:latest ./Backend/odc'
                sh 'docker build -t $FRONTEND_IMAGE:latest ./Frontend'
                sh 'docker build -t $MIGRATE_IMAGE:latest ./Backend/odc'
            }
        }
        stage('SonarQube analysis') {
            steps{
                withSonarQubeEnv() { // Will pick the global server connection you have configured
                    sh './gradlew sonar'
                }
            }
        }
        stage('Push des images sur Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker_hub_creds', url: '']) {
                    sh 'docker push $BACKEND_IMAGE:latest'
                    sh 'docker push $FRONTEND_IMAGE:latest'
                    sh 'docker push $MIGRATE_IMAGE:latest'
                }
            }
        }

        stage('Déploiement local avec Docker Compose') {
            steps {
                sh 'docker compose down || true'
                sh 'docker compose pull'
                sh 'docker compose up -d --build'
            }
        }
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
    }
}
