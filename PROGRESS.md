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
