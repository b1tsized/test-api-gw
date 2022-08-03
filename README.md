# Test API Gateway Terraform

This repo is made to deploy and API Gateway in AWS that will return a `200` response. That response is logged in cloudwatch, which kicks off a lambda function to decode the web log into a single line and sends it as a post request to an EC2 instance running an `HTTP` that echos the `POST` request.

## Pre-reqs

- AWS Account
    - This terraform is set to use a profile that is configured within AWS. You can replace this with AWS keys if a profile isn't configured.
- Terraform >= 1.0.x

## Steps

1. Clone this repo to you local machine.

```console
git clone https://github.com/b1tsized/test-api-gw.git
```

2. `cd` into the directory you just cloned.

```console
cd ./test-api-gw
```

3. Run `terraform init`.

```console
terraform init
```

4. Create a `.tfvars` file that has all the necessary variables. Example is below. Descriptions are found in [`variables.tf`](./variables.tf).

```hcl
profile       = "dev"
region        = "us-west-2"
rest_api_name = "mytestapi"
instance_name = "test-echo-http"
creator       = "terraform"
port          = "8080"
lambda_function_name = "mytestlambda"
```
5. Run `terraform plan` and validate there are no issues and that configured variables are displaying correctly.

```console
terraform plan
```

6. If output is acceptable, then run `terraform apply -auto-approve`.

```console
terraform apply -auto-approve
```

7. Outputs will be displayed for your `aws_instance.linux_instance.public_ip` and the endpoint for your api that you created.

```console
api_gw_get_endpoint = "https://nyln6861n8.execute-api.us-west-2.amazonaws.com/mytestapi/pets"
ec2_address_post_address = "http://54.184.138.111:8080"
```