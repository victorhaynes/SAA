# Section 26 - Security, Encryption, KSM, SSM Parameter Store, Shield, WAF

## 297. Encryption 101

### Encryption  in flight (TLS / SSL)
- remember TLS is just a newer SSL
- encrypted before sending, decrypted after receiving
- TLS certs help with encryption (HTTPS)
- can send data over public networks, prevent MITM attacks (man in the middle)
- client will TLS encrypt, only target can TLS decrypt

### Server-side encryption at rest
- data is encrypted after being received by the server
- data is decrypted before being sent
- it is stored in an encrypted form with a key
- the encryption/decryption keys must be managed somewhere, and the server must have access to it

### Client-side encryption
- data is encrypted by the client and never decrypted by the server
- data will be decrypted by a receiving client
- the server should not be able to decrypt the data

## 299. KMS Overview

### Key Management Server
- AWS encryption likely is using KMS
- AWS manages encryption keys for us
- fully integrated with IAM
- easy way to control access to your data
- Able to audit KMS key usage using CloudTrail `EXAM`
- Seamlessly integrated into most AWS services (EBS, S3, RDS, SSM)
- never ever store your secrets in plaintext, or in code
	- KMS Key Encryption also available through API calls (CDK, SLI)
	- Can encrypt your own secrets with KMS keys and these can be used in your code as environment

### KMS Key Types
- `Symmetric (AES-256)`
	- single encrption key that is used to encrypt and decrypt data
	- AWS services that are itnegrated with KMS use symmetric key
	- You never get access to the KMS Key unencrypted (must call KMS API to use)
- A`symmetric (RSA & ECC Key pairs)`
	- public (encrypt) and private (decrypt) pair
	- public key is downloadable but you can't access the private key unencrypted
	- use case: encryption done outside of AWS by users who don't have access to KMS API

### Types of KMS Keys
- AWS owned (free, SSE-S3, SSE-DDB etc)
- AWS Managed key free (start with `aws/`)
- Customer managed keys in KMS: $1/month
- Customer managed keys imported $1/month
- + pay for API call to KMS $.03 / 10,000 calls

- Automatic key rotations
	- AWS managed auto every 1 y ear
	- customer managed: automatic and on-demand
	- imported: manual only

![Screenshot 2025-08-25 at 2.55.06 PM.png](Screenshot%202025-08-25%20at%202.55.06%20PM.png)

`EXAM` - cannot have the same KMS key in two regions

### KMS Key policies
- control access to KMS keys "similar" to S3 bucket policies
- difference: you cannot control access without them

- Default KMS policy
	- created if you don't provide a specific KMS key policy
	- complete access to the key to the root user = entire AWS account
- custom KMS key policy
	- define users, roles that can access the KMS
	- Define who can administer the key
	- useful for cross-account access of your KMS key

### Copying snapshots across accounts
1. create a snapshot, encrypted with your own KMS key (customer managed key)
2. attach a KMS key policy to authorize cross-account access
3. Share the encrypted snapshot
4. in target- create a copy of the snapshot, encrypt it wit ha CMK in your account

## 301. KMS - Multi-Region Keys

- primary key in one region
- can replicate key into other regions
- same key ID
- identical KMS keys, used interchangeably
- exactly the same
- enables: encrypt in one region, decrypt in others
	- can skip re-encrypt or making cross-Region api calls
- KMS Multi-Region are NOT global (primary + replicas)
- Each multi-region is managed independently
- use case: global client-side encryption in one region & decryption in another `EXAM`


### DynamoDB Global Tables - Client-Side encryption
- We can encrypt specific attributes client-side in DynamoDB using the `Amazon DynamoDB Encryption`
- if the table is global then a client in a different region then encryption would work the exact same using a replicated multi region key

### Global Aurora
- same concept works here with Aurora

## 302. S3 Replication with Encryption

- unencryped obejcts and encrypted objects with SSE-S3 are replicated by default
- object with SSE-C (customer) CAN be replicated
- For objects encrypted with SSE-KMS need to enable
	- specify which kms key to encrypt the objects within the target bucket
	- adapt the ksm key policy for the target key
	- an iam role with kms:Decrypt for the source KMS key and kms:Encrypt for the target KMS Key
	- You might get KMS throttlign errors, in which case you can access for a service quotas increase

## 303. Encrypted AMI Sharing Process

`EXAM`
1. AMI in source account is encrypted with KMS key from source account
2. modify the AMI property to add a `launch permission` add target AWS Account ID
3. Must share the KMS key used to encrypt the snapshot/AMI reference with the target account/IAM role
4. The IAM Role/user in the target account must have the permissions to describekey, reencrypt*, creategrant, decrypt

## 304. SSM Parameter Store Overview

- secure storage for configuration and secrets
- optional seamless encryption using KMS
- serverless scalable, durable, easy SDK
- Version tracking of configurations / secrets
- Security through IAM
- Notifications with Amazon EventBridge
- Integration with CloudFormation

### Store Hierarchy
- /my-org/
	- /my-app/
		- /dev
			- db-url
			- db-password
		- /prod
			- db-url
			- db-password
- /other-deparment/

Etc. self explanatory, but remember


### Tiers
- `Standard` - 4KB, $ free
- `Advanced` - 8KB $0.05 per month
	- parameter policies (advanced only)
		- can assign a TTL for parameters

## 306. AWS Secrets Manager - OVerview

- Newer service
- meant for storing secrets
- Different from SSM store
- Capability to force rotation every X days
- Automate generation of secrets on rotation (uses Lambda)
- Integrates well with RDS, Aurora, other AWS services (i.e. can store DB credentials here)
- `secrets? RDS/aurora integration == Secrets Manager`  EXAM

### Multi-Region Secrets
- Replicate secrets across multiple AWS regions

## 308. AWS Certificate Manager (ACM)

- provision, manage, deploy TLS (SSL) certificates
	- provide in-flight encryption for websites (HTTPS)

i.e. would integrate an ALB with ACM, then user access the ALB via HTTPS, and your web app can then communicate with HTTP protocol if desired

- Free of charge for publicTLS certificates
- integrate with ELBs
- CloudFront
- APIs on API Gateway
- `CANNOT USE ACM ON AN EC2 instance directly`

### ACM Requesting Public Certificates
1. list domain names to be included in the certificate
	1. list fully qualified domain name (FQDN) corp.example.com
	2. or wildcard domain *.example.com
2. select validation method, DNS validation or email
	1. DNS is preferred for automation
	2. Email validation will send emails to contact addresses in the WHOIS database
	3. DNS validation will leverage a CNAME record to DNS config (route 53)
3. Takes a few hours to get verified
4. The public certificate will be enrolled for automatic renewal
	1. ACM auto renews 60 days before expiry

### Importing Public Certs
- if you generated it outside of AWS/ACM you can import it
- No automatic renewal
	- ACM sends daily expiration events 45 days prior to expiration
		- appears in EventBridge as an event
		- then from EventBridge you can trigger handling like SNS or Lambda
	- AWS Config
		- managed rule provided that can check for expiring certificates
			- sends non-compliance event

### ACM - Integration with ALB
- On ALB redirect HTTP -> HTTPS redirect rule

### API Gateway - Endpoint Types
- edge-topimzied (default): for global clients
	- requests are routed through the cloudfront edge locations
	- API gateway still lives in only one region
- regional
	- for clients within the same region
	- could manualyl combine with cloudfront (more control over the chaching strat/and distr)
- private
	- can only be accessed from your VPC usingan interface VPC endpoint (ENI)

### Integrating with API Gateway
- create a custom domain name in API gateway
- edge optimized (default) for global clients
	- TLS certs must be in the same region as CloudFront us-east-1
	- then setup a CNAME (or better) A-Alias record in Route 53
- Regional:
	- for clients within the same region
	- TLS cert must be imported on API gateway in the same region 

## 308. Web Application Firewall (WAF

- Protects your web app from common web exploits (Later 7)
- Layer 7 is HTTP (vs layer 4 which is TCP/UDP)
- Can be deployed on
	- ALB
	- API Gateway
	- CloudFront
	- AppSync, GraphQL API
	- Cognito User Pool
	- `EXAM` cannot deploy on a `NLB`

- define web ACL (access control list) rules:
	- IP set: up to 10,000 IP addresses use multiple rules for more IPs
	- HTTP headers, HTTP body, or URI strings protect from common attacks (SQL injection, cross-site scripting)
	- Size constraints, geo-match (block countries)
	- rate-based rules - for DDoS protection
- Web ACL are regional except for CloudFront
- A rule group is a reusable set of rules that you can add to a web ACL

### Fixed IP while using WAF with a Load Balancer
- WAF does not support the NLB (cuz it's layer 4, and ALBs dont support fixed IPs `EXAM`)

## 310. Shield - DDoS Protection

- Distributed Denial of Service - many requests at the same time
	- goal is to overwhelm and attack infra
- AWS shield standard
	- activate for every AWS customer
	- provide protection from attacks, and layer 3/4 attacks
- Shield Advanced
	- optional DDoS mitigate service ($3,000 per month per org)
	- more sophisticated protection on EC2, ELB, CloudFront, Global Accelerator, Route53
	- 24/7 access to AWS DDoS response team DRP
	- Protect against higher fees during usage spikes due to DDoS

## 311. Firewall Manager

- Manage rules in all accounts of an AWS org
- Security policy: common set of security rules
	- WAF rules, ALBs, API gateways, cloudfront
	- AWS shield advanced (ALB, CLB, NLB, Elastic IP, cloudfront)
	- security groups for EC2, ALB and ENI resource in VPC
	- AWS Network Firewall (VPC level)
	- Route53 Resolver DNS firewall
	- Policies create at the regional level
- Rules re applied to new resources as they are created (good for compliance) across all and future accounts in your ORG

### WAF, Firewall Manager, Shield
- used together
- WAF: web ACL rules, granular protection
- Firewall Manager: cross-acount WAF, accelerate configuration

## 313. DDoS Protection Best Practices

- BPI - cloudfront
	- web application delivery at the edge
	- protect from DDoS common attacks
- BPI - globla accelerator
	- access your app from the edge
	- integration with shield for DDoS protection
	- helpful if your backend is not compatible with cloudfront
- BPI - Route53
	- DNR is at the edge


- Infrastructure layer defense (BP1, BP3, BP6)
	- protect EC2 against high traffic
	- Global Accelerator, Route53, CloudFront, ELB
- EC2 with auto scaling (BP7)
	- helps scale in  case of a sudden flash or DDoS attack
- ELB (BP6)
	- scales with traffic and will distribute traffic to many ec2 instances


- application layer defense
- detect and filter malcious web reqeuts (BP1, BP2)
	- cloudfront cache static content and serve it from edge location protecting your backend
	- WAF used on top of CF and ALB to filter and block requests based on signatures
	- WAF rate-based rules can atuo block IPs of bad actors
	- WAF has manged rules
	- CF can block specific geographies
- Shield advanced (BP1, B2, BP6)
	- DDoS protection
	- WAF layer 7 protection

- attack surface reduction
- obuscating AWS resources (BP1, BP4, BP6)
	- using CloudFront, API Gateway, ELB to hide your backend resources
- Security groups and network ACLs (BP5)
- Protecting API endpoints (BP4)
	- hide ec2, lambda, elsewhere
	- edge optimized mode, or cloudfront + regional mode
	- WAF + API


## 314. Amazon GuardDuty

- Intelligent threat discovery to protect your AWS account
- uses ML algo, anomaly detection
- One click (30 day trial) no installations
- Input data includes
	- CloudTrail Events Logs - unusual API calls, unauthorized deployments
	- VPC flow Logs
	- DNS logs
	- Optional features - EKS audit logs, RDS and Aurora logs, EBS, Lambda, S3 Data Events
- EventBridge Rules to be notified in case of findings
- EventBridge rule cant target AWS lambda or SNS
- `Good for protecting against Crypto Currency attack` `EXAM`


## 315. Amazon Inspector

- Run automated security assessments
- on EC2 instances
	- leverages AWS Systems Manager (SSM) agent
	- analyze against unintended network accessibilities
	- analyze OS against known vulnerabilities
- Container images push to ECR
	- analyzed by inspector
- lambda functions
	- software vulnerabilities, package dependencies


- can report findings to AWS Security Hub
- can send findings to Amazon Event Bridge

### Evaluates:
only for running `EC2 isntance, container images, lambda functions`
that's it
`EXAM`

- package vulnerabilities (all) vs database of CVE
- network reachability (EC2)

## 316. Amazon Macie

- fully managed data security and privacy service that uses ML and pattern matching to discover and protect your sensitive data in AWS
- helps you identify and alert you to sensitive data such as PII
	- can integrate with EventBridge
	- i.e. `find sensitive data in your S3 bucket`
	- apparently S3 only

## Quiz

## Servicer side Encryption (SSE) definition:
encryption and decryption happens on the server, client is unaware


## Do customer-managed CMKs in KMS support automatic key rotation and retention periods?
if you enable automatic rotation on your KMS key, backing key is rotated every year.

## What is a backing key when it comes to KMS?

## You have a secret value that you use for encryption purposes, and you want to store and track the values of this secret over time. Which AWS service should you use?
AWS KMS Versioning feature? or SSM Parameter Store


## GuardDuty scans the following EXCEPT
CloudTrail
VPC Flow Logs
DNS Logs
CloudWatch Logs <-- got it right, intuition is this seems too granular compared to other options

## SQL injection preventing-service?
WAF

## Secrets Manager vs SSM Parameter store?
think RDS integration -> secrets manager


## What even is cloudHSM?


## You have created a Customer-managed CMK in KMS that you use to encrypt both S3 buckets and EBS snapshots. Your company policy mandates that your encryption keys be rotated every 6 months. What should you do?
- enabled automatic key rotation and specify the desired retention period
- follow up: IMPORTED keys (different from CMK in KMS) do not support this


## You have generated a public certificate using LetsEncrypt and uploaded it to the ACM so you can use and attach to an Application Load Balancer that forwards traffic to EC2 instances. As this certificate is generated outside of AWS, it does not support the automatic renewal feature. How would you be notified 30 days before this certificate expires so you can manually generate a new one?


## Where is the only place you can create ACM certificates?
us-east-1


AWS GuardDuty does what?

