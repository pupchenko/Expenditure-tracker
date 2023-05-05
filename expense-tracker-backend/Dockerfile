FROM gradle:7.6.0-jdk17 AS builder
COPY --chown=gradle:gradle . /home/app
WORKDIR /home/app
RUN gradle clean build --no-daemon

FROM openjdk:17-alpine
RUN mkdir /app
COPY --from=builder /home/app/build/libs/*.jar /app/application.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/application.jar"]