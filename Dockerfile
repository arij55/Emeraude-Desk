FROM maven:3.6.0-jdk-8-alpine AS builder
ADD ./pom.xml pom.xml
ADD ./src src/


#Seconde stage: minimal runtime environment


EXPOSE 8080

CMD ["java","-jar","demo-0.0.1-SNAPSHOT.jar"]