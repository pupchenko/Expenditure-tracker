## Expense-tracker

Application for tracking your expenses with React front-end and Java Spring back-end. Can be deployed to AWS by Terraform or run locally.

![img.png](img.png)

### Start up guide local

* Run ***docker-compose up*** in  project root directory to start application.
* React will be running on localhost:3000
* Backend will be running on localhost:8080

### Start up guide and prerequisites Terraform

* Install Terraform from Hashicorp official page
* Specify valid values for your env variables:

      AWS_ACCESS_KEY_ID: your AWS account access key  
      AWS_SECRET_ACCESS_KEY: your AWS account secret key  
      AWS_REGION: specify AWS region

* All following commands should be run in terraform directory.
* Run ***terraform init***  to initialize terraform.
* Run ***terraform plan*** to see resources to be created.
* Run ***terraform apply*** to deploy demo app to aws with all necessary resources.
* Confirm action with typing ***yes***.
* In outputs you will get React website URL and load balancer dns name targeted to back-end
* Backend will need a few minutes to be deployed to EC2 by ECS
* You can view outputs any time after deployment by running ***terraform output***
* Run ***terraform destroy*** to destroy created resources if you no longer need it.

Useful links:

* [Hashicorp official page](https://learn.hashicorp.com/collections/terraform/aws-get-started)

* [Terraform public registry](https://registry.terraform.io/browse/modules?provider=aws)