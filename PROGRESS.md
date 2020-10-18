# Progress

Hey guys, I'll be braindumping my thoughts and opinions on the process here as I work on the mini-project.

## Docker

Setup Docker Compose stack to ensure I can replicate the setup locally.

Looked up PostgreSQL supported version on AWS before setting it up locally.

If we can't replicate the stack locally, what's the point? Container stacks should be developer friendly, not robot friendly.

## OpenJDK or Oracle JDK?

I went with the open source approach but I lack a fair amount of Java knowledge given that I come from a Microsoft shop company.

## Why Terraform?

Having the state of infrastructure stored somewhere can be beneficial to dictate what we want to **change**, this includes deleting, updating and creating. The alternative would be to use the cloud provider's stateless API to build a snapshot of the infrastructure to essentially try mimic what Terraform is doing with state.

Another great benefit is the ability to cross between cloud providers in a single module. Need Azure and GCP setup? Or an ACME cert to be loaded into a key vault? This can all be contained and managed via providers in modules.

### Cons?

Well state can become malformed and we need to take steps to ensure that the state of infrastructure does not *drift* with the reality of what's deployed in the cloud. Operators will need to know how to stateful applications similar to how database engineers require knowledge in change the state of databases.

This is where Terraform can be re-applied to sure the state is always the same as declared.

## Should we still use public registries like Dockerhub?

It depends on the level of security we have at the company. Ideally production workloads should use private registries to act as a DMZ as it gets scanned and deployed to production environments.

## Prometheus wasn't working by default

Looked like we've missed the Prometheus dependency to actually enable the metrics endpoint.

Luckily, Googling the problem solved it.

## AWS and Terraform

We need to provision a few things to provide scalable infrastructure as code. There are two levels of access control here. IAM access specifically for the ECS stack and operator access to provision preliminary resources like the following before the stack.

- Setup Terraform backend state file storage using an S3 bucket
- Setup an IAM user for the ECS stack

Once they're setup we can use the provisioned IAM user to create the ECS stack. This will also provide a safe way to integrate access control into a CI/CD pipeline. The IAM user will be responsible for the resources it creates.

## CI/CD pipelines?

I hope to use GitHub actions to provide PR infrastructure deployments.

## RDS rotating secrets

Did a bunch of research on how to store secrets in AWS. Rotating secrets does sound more secure, though my original approach was to use the `random_password` resource to generate a password to store in the SecretsManager resource. This would drop the feature of rotating secrets on the RDS. I will try the work towards the rotating secrets, which is only available in using AWS SecretsManager.

The alternative is to use SSM with the `random_password` approach to store it and fetch it at the ECS task. Though we put the state file into scope in storing credentials. We'd still use the ARN to load it into the ECS task by the way.

Introducing rotating secrets does come with more implementation in terms of applying it outside of ECS when using SecretsManager. It just depends on the ergonomics to SecretsManager from other cloud resources non-AWS and AWS. Kubernetes would be an example, I'd guess that it would have an operator deployed in the cluster to monitor SecretsManager key rotation and apply rolling deployments on downstream pods.

Rotating secrets are a good idea, however this will require additional time to tune a custom lambda function to actually invoke a rotation on the AWS SecretsManager. I have relevant experiences with Azure Functions, so this should be similar. Fallback here is to drop rotating secrets in the meantime.

## Subnet availability zones

Something I've learnt when I first ran the Terraform template. We need at least 2 availability zones to setup an RDS instance in AWS. This isn't a thing in Azure.

## Comparing to Kubernetes

This ECS stack feel like similar to hosting a Kubernetes cluster, though it does feel like we're locked into the vendor at a fair amount like SecretsManager and task definitions. An argument against that is we get to fully utilise the providers features.

ECS task definitions feel like Kubernetes Deployment manifests without the deployment strategy.

## Troubleshooting ECS containers

Looks like we have the following offers to get into an ECS instance to troubleshoot. We can SSH into the instance and dump logs or try install AWS audit tools on the container to forward logs to the CloudWatch instance.

This feels fairly complex compared to viewing pod events and logs in a Kubernetes cluster via `kubectl`.
