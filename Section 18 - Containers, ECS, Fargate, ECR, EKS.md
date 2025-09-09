# Section 18 - Containers, ECS, Fargate, ECR, EKS

## 200. Docker

- packed containerized apps that can run on any OS
- any machine
- no compatibility issues
- predictable behavior
- easier maintenance
- use case: microservice architecture, lift and ship apps from on prem to the cloud


Docker imags / hub
- find base images for many technologies or OS (Ubuntu, MySQL)

vs Amazon's ECR
- public and private options

### Virtualization-like technology
- resources are shred with the host, can have many containers on one server
- EC2 for instance is ran by a hypervisor that runs on the physical server
- instead of a hypervisor docker relies on a docker daemon to orchestrate its containers


### Getting started
- need Dockerfile
- build using a docker image
- push image to dockerhub (public) or Amazon ECR (private)
	- can pull image
- docker image can than be ran


### ECS
- Amazon's own container platform

### EKS
- Amazon's managed version of Kubernetes

### Fargate
- own severless container platform

## 201. ECS

### EC2 Launch Type
- ECS = elastic container service
- a launch docker container on AWS = launch ECS tasks on EC2 clusters
- EC2 Launch Type: you must provision & maintain the infrastructure (the EC2 instances)
- each EC2 instance must run the ECS agent to register in the ECS cluster
- AWS takes care of starting/stopping containers 

### Fargate Launch Type
- launch docker containers on AWS
- do no provision infra
- serverless
- just create task definitions
- AWS runs ECS Taks for you based on the CPU/RAM needed
- to scale just increase the number of tasks. Simple no EC2 to manage
- `EXAM`

### IAM Roles for ECS
- EC2 Instance Profile (EC2 Launch Type only)
	- used by the ECS agenet
	- make api calls to ECS service
	- send container logs to cloudwatch
	- pull docker image from ECR
	- reference sensitive data in secrets manager or SSM parameter store
- ECS Task role:
	- allows each task to have a specific role
	- different roles for different services
	- task role is defined in the task definition

### Load Balancer Integrations
- Can put an ALB in front of an ECS cluster
- NLB recommended only for high throughput / high performance uses cases or pair it with AWS Private Link `EXAM`
- Classic Load Balancer works but not commended (does not work with Fargate)

### Data Persistence on ECS
- Mount EFS file system onto ECS tasks
- Works for both EC2 and fargate launch types
- Tasks running in any Az will share the same data in the EFS file system
- Fargate + EFS = Serverless
- Use Cases: persistent multi-AZ shared storage for your containers
- Note:
	- S3 CANNOT be mounted as a file system for ECS tasks




### ECS Hands On 203
Three Infrastructure Options
- AWS Fargate Pay as you go
- EC2 instances
- External instances using ECS anywhere (on-prem)

### ECS Service Hands on 204
- need task definition


`Review ECS`

## 205. ECS Service Auto Scaling

- can manually or automatically increase desired number of ECS tasks
- Can use AWS Application Auto Scaling
	- can scale on service average cpu util
	- service average memory util
	- ALB request count per target
- Target tracking
- Step Scaling
- Scheduled scaling

Task level scaling != EC2 auto scaling `Review`
Fargate auto scaling is much easier to setup
`EXAM`


### Auto Scaling EC2 Instance - EC2 Launch Type
- accommodate ECS service scaling by adding underlying EC2 instance
- Auto scaling group scaling
	- scale ASG basd on cpu util
	- add ec2 instances over time
- ECS cluster capacity provider
	- new/advanced
	- used to automatically provision and scale the infra for your ECS tasks
	- capacity provider paired with an ASG
	- add EC2 instances when you're missing capacity
	- `best option most of the time EXAM`

## 206. ECS Solution Architectures

### ECS tasked invoked by Event Bridge
Serverless object processing architecture using Event Bridge, ECS, and Fargate
![Screenshot 2025-08-18 at 1.39.41 PM.png](Screenshot%202025-08-18%20at%201.39.41%20PM.png)

### Event Bridge Schedule (ex. every 1 hour)
serverless hourly batch processing![Screenshot 2025-08-18 at 1.40.37 PM.png](Screenshot%202025-08-18%20at%201.40.37%20PM.png)

### SQS Queue
![Screenshot 2025-08-18 at 1.43.44 PM.png](Screenshot%202025-08-18%20at%201.43.44%20PM.png)

### EventBridge to intercept events within your ECS cluster
i.e. if a task exists it gets captured by EventBridge and SNS can then email an admin![Screenshot 2025-08-18 at 1.44.41 PM.png](Screenshot%202025-08-18%20at%201.44.41%20PM.png)


## 208. ECR

Elastic Container Registry
- store and manage docker images on AWS
- Private and public storage options
- Fully integrated with ECS backed by amazon S3

EC2 instance would need an IAM Role to pull an image from ECR


## 209. EKS

### Elastic Kubernetes Service
- Way to launch managed kuerbentes clusters on AWS

### Kubernetes
- open-source system for automatic deployment, scaling and management of containerized application
	- think of it as an open source alternative to ECS. similar usage but different  API
	- use case: already using kubernetes on prem or in another cloud
	- then use EKS on AWS to migrate
	- kubernetes is cloud-agnostic `EXAM` while ECS is not

EKS pods are like ECS tasks
EKS pods run on EKS nodes
EKS nodes can be managed by an ASG
Public and privte LBS can eb used

### EKS Node Types
- Managed Node Groups
	- creates and manages Nodes (EC2 instance) for you
	- aprt of an ASG managed by EKS
	- supportson demad and sport isntance
- Self managed nodes
	- nodes created by you and registered to the EKS cluster and maanged by an ASG
	- can sue prebuilt AMI Amaazon EKS Optimized AMI
	- Supports on demand or spot isntance
- Fargate
	- No maintenance required, no nodes managed

### EKS Data Volumes
- must specify a `StorageClass` manifest on your EKS cluster `EXAM`
- Leverage a `Container Storage Interface` (CSI) compliant driver `EXAM`

Support for
- EBS
- EFS
- FSx for Lustre
- FSx for NetApp ONTAP

### 207 Hands On

## 211. App Runner

- fully managed service that makes it easy to deploy web applications and APIs at scale
- no infra experience required
- start with your source code or container image
- configure settings like CPU, RAM, ASG yes/no, health checks
- then automatically builds and deploy the web app
- automatic scaling, high availability, low balancer
- VPC access support
- can connect to database, cache, message queue services
- Use cases: web apps, APIs, microservices, rapid production deployments etc


## 213. App2Container

- CLI tool for migrating and modernizing Java and .NET web apps into Docker Containers
- Lift-and-shift your apps running on-prem or other clouds to AWS
- Accelerate modernization, no code changes, migrate legacy apps
- Generates CloudFormation Templates
- Register generated Docker containers to ECR
- Deplyo to ECS, EKS, or App Runner
- Supports pre-built CI/Cd pipelines

