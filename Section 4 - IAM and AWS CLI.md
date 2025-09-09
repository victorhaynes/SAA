# Section 4 - IAM and AWS CLI

## 1-IAM Summary


`Users` - mapped to a physical user
`Groups` - contains users (groups cannot contain user groups)
`Policies`  - JSON document that outlines permissions for users or groups
`Roles` - for EC2 instance or AWS services
`Security` - MFA + password policies
`AWS CLI` - manage AWS services using command line interface
`AWS SDK` - manage AWS services using a programming language
`Access KEYS` - access AWS using the CLI or SDK
`Audit` - IAM credential reports & IAM access advisor


Policy statements are made up of:
- Effect
- Principal
- Action
- Resource

