FROM tomcat 
WORKDIR webapps 
COPY target/WebApp-1.0-SNAPSHOT.jar .
RUN rm -rf ROOT && mv WebApp-1.0-SNAPSHOT.jar ROOT.jar
#ENTRYPOINT ["java", "jar", "ROOT.jar"]
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]
