node {

    stage('Checkout Git') {
        checkout scm // Checks out code from configured SCM
    }

    stage('Build Docker Image') {
        def customImage = docker.build("hello_aws:${env.BUILD_ID}")
    }
    
    stage('Test Deployment') {
        sh 'docker run -d --name test_hello -p 8888:80 hello_aws'
        // 'docker stop test_hello'
        // 'docker rm test_hello'
        // 'docker rmi hello_aws'
    }

    stage('Push des images sur Docker Hub') {
        customImage.push('latest')
    }

}
