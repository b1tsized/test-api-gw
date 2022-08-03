### UBUNTU IMAGE ###

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

### LAMBDA ZIP ###

data "archive_file" "lambda_function" {
  type        = "zip"
  output_path = "${path.module}/template/lambda.zip"
  source_dir  = "${path.module}/python"
  depends_on = [
    local_file.lambda_python
  ]
}
