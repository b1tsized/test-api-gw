### ECHO PROXY ADDRESS ###

output "ec2_address_post_address" {
  value = "http://${aws_instance.linux_instance.public_ip}:${var.port}"
}

### API ENDPOINT ###

output "api_gw_get_endpoint" {
  value = "${aws_api_gateway_stage.api_gw_stage.invoke_url}/${aws_api_gateway_resource.api_gw_resource.path_part}"
}
