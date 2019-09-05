resource "aws_security_group" "sgforecrendpoint" {
  name        = "ECREndpointSG"
  description = "Allow indbound and outbound traffic for ecr endpoint"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


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