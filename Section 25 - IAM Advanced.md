# Section 25 - IAM Advanced

## 287.  Organizations

- global service
- allows to manage multiple AWS accounts
- the main account is the `management account`
- other accounts are `member accounts`
- member accounts can only be part of one organization
- consolidated billing across all accounts - single payment method
- `pricing benefits from aggregated usage`
- share reserved instances and savings plans discounts across accounts
- API is available to automate AWS account creation

### Organizational Units (OU) - Examples
i.e. can have business units, environment OUs (prod, dev, staging), or project-based
can organize however you want

### Advantages
- multi account vs one account with multiple VPCs
- use tagging standards for billing purposes
- enable cloudtrail on all accounts, central s3 storage
- send cloudwatch logs to central logging account
- establish cross account roles for admin purposes

`Security: Service Control Policies (SCP)`
- IAM policies applied to OU or Accounts to restrict users and roles
- they do not apply to the management account (full admin power)
- must have an explicitly allow from the root through each OU in the direct path to the target account (does not allow anything by default like IAM)

### SCP Hierarchy
- SCPs cannot apply to the mangement account period `EXAM` no matter what


## 289. Organizations Tag Policies

- helps standardize tags across resources in an AWS organization
- ensure consistent tags, audit tagged resources, maintain proper resource categorizations
- define tag keys and their allowed values
- helps with AWS cost allocation tags and attribute-based access control
- prevent non-compliant tagging operations
- generate compliance reports
- can use EventBridge to monitor non-compliant tags

## 290. IAM Advanced Policies

### IAM Conditions
- `aws:SourceIp` restrict the client FROM which the API calls are being made (caller's IP address)
- `aws:RequestedRegion` restrict the region the API calls are made TO
- `ec2:ResourceTag` restrict based on tags
- `aws:MultiFactorAuthPresent` to force MFA

### Example IAM Policy for S3
```json
{
	"Verison": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": ["s3:ListBucket"],
			"Resource": "arn:aws:s3:::test"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::test/*"
		},
	]
}
```
`s3:ListBucket` is a bucket level permission
```json
			"Resource": "arn:aws:s3:::test"
```

`s3:GetObject` or get/put/delete are OBJECT level permissions so `bucket-name/<object-name>`
```json
			"Resource": "arn:aws:s3:::test/*"
```
`EXAM`
### Resource Policies & `aws:PrincipalOrgID`:

## 291. IAM Resource based Policies vs IAM Roles

IAM Roles vs Resource Based Policies

- Cross Account
	- attaching a resource-based policy to resource (Example s3 bucket policy)
	- OR using a role as proxy (user in account A can assume a role in account B)

- when you assume a role, you give up your original permissions and take the permissions assigned to the role
- when using a resource-based policy, the principal (the who)
- doesn't have to give up their permissions

	S3, SNS topics, SQS queues, lambda, API gateway all support `resource based policies` `EXAM`

### EventBridge Security
- when a rule runs it needs permissions on the target
- if the target doesn't support resource based policies then it will rely on IAM role (i.e. ec2 auto scaling)

## 292. IAM Policy Evaluation Logic

- `IAM Permission Boundaries` supported for users and roles (not groups)
- advanced feature to use a managed policy to set the maximum permissions an IAM entity can get

- Basically think of it as a "higher level" permission that sets what a lower level can do, even if the lower level has an explicit allow

- Can be used in combinations of AWS Organizations SCP

![Screenshot 2025-08-25 at 2.04.28 PM.png](Screenshot%202025-08-25%20at%202.04.28%20PM.png)

Use cases
- delegate responsibilities to non administrators within their permission boundaries
- allow for developers to self-assign policies and manage their own permissions while enforcing boundaries
- restrict individual users, without applying an SCP to your entire account

`Denies override allows`


## 293. AWS IAM Identity Center

- successor to SSO
- one login for all your 
	- AWS accounts in AWS organizations
	- Business cloud applications (salesforce, Box, Microsoft)
	- SAML2.0-enabled applications
	- EC2 windows instances
- Identity providers
	- Built-in identity store in IAM identity center
	- 3rd party: Active Directory (AD), OneLogin, Okta


Can integrate with something like Active Directory or the built-in IAM Identity Center Identity Store

- define `permission sets`

`EXAM` - review
![Screenshot 2025-08-25 at 2.15.14 PM.png](Screenshot%202025-08-25%20at%202.15.14%20PM.png)

AWS Fine-grained permissions and assignments
- multi-account permissions
	- manage across AWS accounts in your Org
	- permission sets - a collection of one or more IAM policies assigned to users and groups to define AWS access
- application assignments
	- SSO access to many SAML 2.0 business applications (salesforce, box, microsoft 365)
	- provide required URLs, certs, metadata
- attribute-based access control (ABAC)
	- fine-grained permissions based on user's attributes stored in IAM identity center identity store
	- use case: define permission once, then modify AWS access by changing the underlying attributes

## 294. AWS Directory Services

### What is Microsoft Active Directory (AD)
- found on any windows server with AD domain services
- Database of objectS: User Accounts, Computers, Printers, File Shares, Security Groups
- Centralized security management, account creation, assign permissions
- Objects are organized into trees, a group of trees is a forest

### AWS Directory Services
- a way to create an AD on AWS
- `AWS Managed Microsoft AD`
	- create your own AD in AWS, manage users locally, supports MFA
	- can establish a 'trust' connection with your on-prem AD
	- think: both are valid/source of truth
- `AD Connector`
	- direct gateway (proxy) to redirect to on-prem AD, supports MFA
	- Users are managed on the on-prem AD
- `Simple AD`
	- AD-compatible managed directory on AWS
	- cannot be joined with on-prem
	- think: if you do not have any on-prem AD

### IAM Identity Center - AD Integration
- Connect to an AWS Managed Microsoft AD 
	- out of the box integration
- Connect to a self-managed AD
	- create a `two-way trust relationship` using AWS managed microsoft AD

## 296. AWS Control Tower

- easy way to setup and govern a secure and compliant multi-account AWS environment based on best practices
- AWS control tower uses AWS organizations to create accounts

- benefits
	- automate the setup of environment in a few clicks
	- automate ongoing policy management using `guardrails`
	- detect violations
	- dashboard

### Guardrails
- Provide ongoing governance for your control tower environment (AWS Accounts)
- Preventative Guardrail - using SCP (restrict regions across all accounts)
- detective guardrail - using AWS config (identity untagged resources)

