node {

    stage('Checkout Git') {
        checkout scm // Checks out code from configured SCM
    }

    stage('Build Docker Image') {
        sh 'docker build -t hello_aws .' 
    }
    
    stage('Test Deployment') {
        sh 'docker run -d --name test_hello -p 8888:80 hello_aws'
        sh 'docker stop test_hello && docker rm test_hello'
        sh 'docker rmi hello_aws'
    }

    stage('Push des images sur Docker Hub') {
        steps {
            withDockerRegistry([credentialsId: 'Docker_hub_cred', url: '']) {
                sh 'docker push hello_aws:latest'
            }
        }
    }

    stage('Notify Success') {
        emailext (
            subject: "SUCCESS: Docker Image Pushed - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
            Docker image built and pushed successfully!
            Image: ${dockerImageName}:${env.BUILD_NUMBER}
            Build URL: ${env.BUILD_URL}
            """,
            to: 'marieme.dieye@uahb.sn'
        )
    }
    
}
