node {
  stage('SCM') {
    checkout scm
  }

  stage('SonarQube Analysis') {
    def mvn = tool 'maven';
    withSonarQubeEnv() {
      sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=webapp-pipeline -Dsonar.projectName='webapp-pipeline'"
    }
  }

  // Adding a quality gate check to ensure the build stops if SonarQube analysis fails
  stage('Quality Gate') {
    timeout(time: 1, unit: 'MINUTES') { // Optional: add a 1 minutes timeout for the quality gate check
      def qg = waitForQualityGate()
      if (qg.status != 'OK') {
        error "Pipeline aborted due to quality gate failure: ${qg.status}"
      }
    }
  }

  stage('Deploy to Tomcat') {
        sh "/var/jenkins_home/deploy_war.sh"
  }
}