FROM openjdk:17-jdk-slim
COPY target/sample-app.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
