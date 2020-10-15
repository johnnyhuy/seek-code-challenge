FROM docker.io/adoptopenjdk/openjdk11:alpine AS build

WORKDIR /tmp/test-application

# Download Gradle first to cache the tooling, useful if we're making app changes
COPY gradle /tmp/test-application/gradle
COPY gradlew /tmp/test-application/gradlew
COPY build.gradle /tmp/test-application/build.gradle
COPY settings.gradle /tmp/test-application/settings.gradle
RUN chmod +x /tmp/test-application/gradlew
RUN ./gradlew

COPY . /tmp/test-application

RUN chmod +x /tmp/test-application/gradlew
RUN ./gradlew build

# Let's keep the image as slim as possible, Alpine Linux works wonders here
FROM docker.io/adoptopenjdk/openjdk11:alpine-slim AS deploy

# Let's multi-build and just fetch the .jar
COPY --from=build /tmp/test-application/build/libs/test-application.jar /srv/test-application/test-application.jar

ENTRYPOINT ["java", "-jar", "/srv/test-application/test-application.jar"]

# I hope you're running BuildKit to take advantage of multi-stage builds ;)

# TODO: non-root user in container
