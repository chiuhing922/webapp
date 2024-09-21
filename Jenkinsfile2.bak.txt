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
        def cred = credentials('tomcat-ssh-private-key')
        def user = "tomcat"
        def tomcat_server = "70af36e83265"
        def remote_war_path = "/usr/local/tomcat/webapps"
        def local_war_path = "/var/jenkins_home/workspace/webapp-pipeline/target"
        def war_file="WebApp.war"
        sh 
          ssh -i ${cred} ${user}@{tomcat_server} "rm -rf {remote_war_path}/WebApp; rm -f {remote_war_path}/WebApp.war"
          scp -i ${cred} {local_war_path}/{war_file} ${user}@{tomcat_server}:{remote_war_path}/WebApp.war
          ssh -i ${cred} ${user}@{tomcat_server} "chown ${user}:${user} {remote_war_path}/WebApp.war"
          ssh -i ${cred} ${user}@{tomcat_server} "/usr/local/tomcat/bin/catalina.sh start"
        
  }
}