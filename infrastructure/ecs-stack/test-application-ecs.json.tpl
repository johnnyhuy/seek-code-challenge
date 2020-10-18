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
        "value": "${ds_host}"
      },
      {
        "name": "DS_DBNAME",
        "value": "${ds_dbname}"
      },
      {
        "name": "DS_USER",
        "value": "${ds_user}"
      },
      {
        "name": "DS_PORT",
        "value": "${ds_port}"
      }
    ],
    "secrets": [
      {
        "name": "DS_PASSWORD",
        "valueFrom": "${ds_password}"
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