node {
	
    // Define variables
    def customImage
    def dockerHubCreds = 'Docker_hub_cred'  // Your Jenkins credentials ID

    stage('Checkout Code') {
        echo 'Checking out source code...'
        checkout scm
    }

    stage('Build') {
        echo 'Building the image...'
        customImage = docker.build("marieme21/hello_aws")
    }

    stage('Test') {
        echo 'Testing run in local'
        sh 'docker run -d --name test_hello -p 8888:80 hello_aws'
    }

    stage('Push') {

        docker.withRegistry('https://registry.hub.docker.com', dockerHubCreds) {
            customImage.push('latest')
        }
    }

}
