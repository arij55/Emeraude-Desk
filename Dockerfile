FROM openjdk:11
LABEL version="1.0" maintainer="Arij Khchérif <https://github.com/arij55>"
COPY target/demo-0.0.1-SNAPSHOT.war demo-0.0.1-SNAPSHOT.war


ENTRYPOINT ["java","-war","demo-0.0.1-SNAPSHOT.jar"]
