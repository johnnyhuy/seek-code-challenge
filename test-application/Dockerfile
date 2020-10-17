FROM adoptopenjdk/openjdk11:alpine AS build

# /tmp since it's definitely temporary
COPY . /tmp/test-application

WORKDIR /tmp/test-application

RUN ./gradlew build

# Let's keep the image as slim as possible, Alpine Linux works wonders here
FROM adoptopenjdk/openjdk11:alpine-slim AS deploy

# Let's multi-build and just fetch the .jar
COPY --from=build /tmp/test-application/build/libs/test-application.jar /srv/test-application/test-application.jar

ENTRYPOINT ["java", "-jar", "/srv/test-application/test-application.jar"]

# I hope you're running BuildKit to take advantage of multi-stage builds ;)

# TODO: non-root user in container
