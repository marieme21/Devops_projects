node {

    checkout scm // Checks out code from configured SCM
    def customImage = docker.build("hello_aws:${env.BUILD_ID}")

}
