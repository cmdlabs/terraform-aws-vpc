resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.ap-southeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  #security_group_ids = ["sg-bf9ce5c4"]
  subnet_ids         = ["aws_subnet.private.id","aws_subnet.secure.id"]
  private_dns_enabled = true
  tags = {
    Environment = "test",
    Name = "TFVpce1"
  }
}

resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.ap-southeast-2.ecr.api"
  vpc_endpoint_type = "Interface"
  #security_group_ids = ["sg-bf9ce5c4"]
  subnet_ids         = ["aws_subnet.private.id","aws_subnet.secure.id"]
  private_dns_enabled = true
  tags = {
    Environment = "test",
    Name = "TFVpce2"
  }
}