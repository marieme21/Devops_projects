node {

    // Define variables
    def dockerHubCreds = 'Docker_hub_cred'  // Your Jenkins credentials ID

    stage('Checkout Code') {
        echo 'Checking out source code...'
        checkout scm
    }

    stage('Build') {
        echo 'Building the image...'
        def customImage = docker.build("hello_aws:latest")
    }

    stage('Test') {
        echo 'Testing run in local'
        def customImage = docker.build("hello_aws:latest")
    }

    stage('Push') {

        docker.withRegistry('https://registry.hub.docker.com', dockerHubCreds) {
            customImage.push('latest')
        }
    }

}
