node {
  stage('SCM') {
    checkout scm
  }
  environment {
    TOMCAT_CREDS=credentials('tomcat-ssh-private-key')
    TOMCAT_SERVER="70af36e83265"
    ROOT_WAR_LOCATION="/usr/local/tomcat/webapps"
    LOCAL_WAR_DIR="/var/jenkins_home/workspace/webapp-pipeline/target"
    WAR_FILE="WebApp.war"
  }

  
  stage('SonarQube Analysis') {
    def mvn = tool 'maven';
    withSonarQubeEnv() {
      sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=webapp-pipeline -Dsonar.projectName='webapp-pipeline'"
    }
  }
  stage('Deploy to Tomcat') {
    steps {
        sh '''
          ssh -i $TOMCAT_CREDS $TOMCAT_CREDS_USR@$TOMCAT_SERVER "rm -rf $ROOT_WAR_LOCATION/WebApp; rm -f $ROOT_WAR_LOCATION/WebApp.war"
          scp -i $TOMCAT_CREDS $LOCAL_WAR_DIR/$WAR_FILE $TOMCAT_CREDS_USR@$TOMCAT_SERVER:$ROOT_WAR_LOCATION/WebApp.war
          ssh -i $TOMCAT_CREDS $TOMCAT_CREDS_USR@$TOMCAT_SERVER "chown $TOMCAT_CREDS_USR:$TOMCAT_CREDS_USR $ROOT_WAR_LOCATION/WebApp.war"
          ssh -i $TOMCAT_CREDS $TOMCAT_CREDS_USR@$TOMCAT_SERVER "/usr/local/tomcat/bin/catalina.sh start"
        '''
      }
  }
}