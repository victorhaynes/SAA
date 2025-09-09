# Section 20 - Serverless Architectures

## 232. Mobile App - MyTodoList

- Requirements
	- expose a REST API witH HTTPS endpoints
	- serverless
	- users diretly interact with their own folder in S3
	- users have serverless amanged authentication
	- users can write and read to dos, but mostly read
	- database should scale with high read throughput


mobile client -> Amazon API gateway -> lambda -> dynamo
		Cognito Authentication


`Temporary crednetials stored in cognito NOT on mobile client`
`EXAM`


## 233. Mobile App - MyBlog.com

- global scaling
- rare writing, often reading
- website is purely static files
- caching must be implemented where possible
- new subs need a welcome email
- photos should have thumbnail generation

client -> cloudfront -> s3

Give S3 a bucket policy:
only authorize from cloudfront distribution (prevents direct access if a user knows the s3 url)


## 234. MicoServices Architecture

synchronous patterns
- API gateway, load balancers
Asynchronous patterns

## 235. Software updates distribution

- we host the patch on ec2
- many incoming requests whenever patches are required

just put cloudfront infront of your existing classic architecture

