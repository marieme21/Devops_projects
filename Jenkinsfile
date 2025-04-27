node {
    // Define variables
    def dockerImageName = "marieme21/hello_jenkins"
    def dockerHubCreds = 'Docker_hub_cred' // Jenkins credentials ID

    stage('Checkout Git') {
        checkout scm // Checks out code from configured SCM
    }

    stage('Build Docker Image') {
        docker.build("${dockerImageName}:${env.BUILD_NUMBER}")
    }

    stage('Push to Docker Hub') {
        docker.withRegistry('https://registry.hub.docker.com', dockerHubCreds) {
            // Push versioned image
            docker.image("${dockerImageName}:${env.BUILD_NUMBER}").push()
            
            // Also push as 'latest'
            docker.image("${dockerImageName}:${env.BUILD_NUMBER}").push('latest')
        }
    }

    stage('Test Deployment') {
        try {
            // Run container temporarily to verify it works
            sh "docker run -d --name test-container -p 8888:80 ${dockerImageName}:${env.BUILD_NUMBER}"
            sleep(time: 5, unit: 'SECONDS') // Wait for Nginx to start
            
            // Verify HTML is served
            def response = sh(script: "curl -s http://localhost:8888", returnStdout: true).trim()
            if (!response.contains("Hello World")) {
                error("Test failed: HTML content not found!")
            }
            
            echo "✅ Test passed - HTML page is serving correctly!"
        } finally {
            // Clean up container
            sh "docker stop test-container || true"
            sh "docker rm test-container || true"
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
