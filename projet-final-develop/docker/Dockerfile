FROM openjdk:13-ea-19-jdk-alpine3.9
VOLUME /tmp
ARG JAR_FILE
COPY restfulweb-1.0.0-SNAPSHOT.jar /tmp/app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/tmp/app.jar"]