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
  stage('Deploy to Tomcat') {
        sh "/var/jenkins_home/deploy_war.sh"
  }
}