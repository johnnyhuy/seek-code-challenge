FROM openjdk:11-jdk-alpine AS build

# /tmp since it's definitely temporary
COPY test-application /tmp/test-application

RUN /tmp/test-application/gradle build

# Let's keep the image as slim as possible, Alpine Linux works wonders here
FROM openjdk:11-jdk-alpine AS deploy

# Let's multi-build and just fetch the .jar
COPY --from=build /srv/test-application/build/libs/test-application.jar

ENTRYPOINT ["java", "-jar", "/srv/test-application/test-application.jar"]

# I hope you're running BuildKit to take advantage of multi-stage builds ;)

# TODO: non-root user in container