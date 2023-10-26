#
# Build stage
#
FROM maven:3.9.3-sapmachine-17 AS build
COPY PROGRAM_CHECK_SYSTEM/src /home/app/src
COPY PROGRAM_CHECK_SYSTEM/pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM openjdk:17-alpine

ENV SERVER_ENDPOINT  http://backend:8000/api/check_system_callback
ENV ENV_EXECUTOR_ENABLE true
ENV ENV_EXECUTOR_RUN_COMMAND python3
ENV ENV_EXECUTOR_FILENAME main.py

RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python

COPY --from=build /home/app/target/ProgramCheckSystem-1.0-SNAPSHOT.jar /usr/local/lib/demo.jar
EXPOSE 7070
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]