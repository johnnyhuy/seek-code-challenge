[
  {
    "name": "test-application",
    "image": "docker.io/johnnyhuy/seek-test-application:v0.0.1",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080,
        "protocol": "tcp"
      }
    ],
    "cpu": 1,
    "environment": [
      {
        "name": "DS_HOST",
        "value": "blah"
      },
      {
        "name": "DS_DBNAME",
        "value": "blah"
      },
      {
        "name": "DS_USER",
        "value": "blah"
      },
      {
        "name": "DS_PASSWORD",
        "value": "blah"
      },
      {
        "name": "DS_PORT",
        "value": "blah"
      }
    ],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 2048,
        "hardLimit": 2048
      }
    ],
    "mountPoints": [],
    "memory": 512,
    "volumesFrom": []
  }
]