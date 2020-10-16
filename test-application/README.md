# Test Application

Basic Spring boot app that stores messages in a Postgres DB and retrieves them.

## Endpoints

`GET /v1/getMessages`

Produces: `application/json`

Retrieves all the stored messages from the DB and returns them in a JSON format. This is unauthenticated.

`POST /v1/putMessage`

Accepts: `text/plain`
Produces: `application/json`

Enters a new message into the database. The `text/plain` post body is the message.
This requires authentication via the `X-Api-Token` header (see `auth.token` for how to configure).

## Build

```
./gradlew build
```

This will produce `build/libs/test-application.jar`.

## Usage

Starting:

```
java -jar build/libs/test-application.jar
```

Retrieving all messages stored in the database (starts empty):

```
curl -X GET -H "Accepts: application/json" http://localhost:8080/v1/getMessages
```

Entering a message in the database:

```
curl -d "Testing" -H "X-Api-Token: example" -H "Content-Type: text/plain" -H "Accepts: application/json" -X POST http://localhost:8080/v1/putMessage
```

Health check:

```
curl http://localhost:8080/actuator/health
```

The health check returns HTTP 200 when all is OK, 5xx (e.g. 503) when not OK.
The health check includes a status check for database connectivity.

## Configuration

Configuration can be done via `application.properties` or environment variables.
Environment variables take the format of UPPERCASE and `_` instead of `.`. E.g. `DS_HOST`/`ds.host`.

The configured database must be Postgres.

| Property | Description |
|:---------|:------------|
| `ds.host` | The database host, e.g. `localhost`. |
| `ds.port` | The port to use when connecting to the database. |
| `ds.dbname` | The database name, e.g. `test`. |
| `ds.user` | The username to connect to the database using. |
| `ds.password` | The password to connect to the database using. |
| `auth.token` | The authentication token to use for client authentication (via `X-Api-Token` header). |
