FROM tomcat:jre21
LABEL maintainer="chiuhing@gmail.com"
ADD webapp.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]