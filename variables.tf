### AWS ###

variable "profile" {
  type        = string
  description = "AWS Profile to use."
}

variable "region" {
  type        = string
  description = "AWS Region you'd like to use for your terraform."
}

variable "rest_api_name" {
  type        = string
  description = "Name you'd like to give the AWS API."
}

variable "instance_name" {
  type        = string
  description = "Name of the EC2 Instance Created."
}

variable "creator" {
  type        = string
  description = "Your name for tagging of EC2 Instance."
}

variable "port" {
  type        = string
  description = "Number you'd like to use for open port on the EC2 Instance."
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the lambda function you'd wish to create."
}
