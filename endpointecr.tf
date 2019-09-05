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
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  service_name = var.service_name_ecr_dkr
  vpc_endpoint_type = var.vpc_endpoint_type_ecr
  security_group_ids = ["${aws_security_group.sgforecrendpoint.id}"]
  subnet_ids         = ["${aws_subnet.private[count.index].id}"]
  tags = {
    Environment = "test",
    Name = "TFVpce1"
  }
}

resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  service_name = var.service_name_ecr_api
  vpc_endpoint_type = var.vpc_endpoint_type_ecr
  security_group_ids = ["${aws_security_group.sgforecrendpoint.id}"]
  subnet_ids         = ["${aws_subnet.private[count.index].id}"]
  tags = {
    Environment = "test",
    Name = "TFVpce2"
  }
}