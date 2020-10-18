{
  "Parameters": {},
  "Resources": {
    "SecretRDSInstanceAttachment": {
      "Type": "AWS::SecretsManager::SecretTargetAttachment",
      "Properties": {
        "SecretId": "${secret_arn}",
        "TargetId": "",
        "TargetType": "AWS::RDS::DBInstance"
      }
    },
    "SecretRotationSchedule": {
      "Type": "AWS::SecretsManager::RotationSchedule",
      "DependsOn": "SecretRDSInstanceAttachment",
      "Properties": {
        "SecretId": "${rds_arn}",
        "HostedRotationLambda": {
          "RotationType": "PostgreSQLSingleUser",
          "RotationLambdaName": "SecretsManagerRotation",
          "VpcSecurityGroupIds": "${vpc_security_group_ids}",
          "VpcSubnetIds": "${vpc_subnet_ids}"
        },
        "RotationRules": {
          "AutomaticallyAfterDays": 30
        }
      }
    }
  }
}
