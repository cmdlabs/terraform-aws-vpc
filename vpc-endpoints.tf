resource "aws_security_group" "sgforendpoint" {
  name        = "EndpointSG"
  description = "Allow indbound and outbound traffic for VPC endpoint"
  vpc_id      = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "allow_all_ingress" {
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sgforendpoint.id}"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sgforendpoint.id}"
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  for_each            = toset(var.vpc_endpoints)
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = "true"
  security_group_ids  = [aws_security_group.sgforendpoint.id]
  subnet_ids          = aws_subnet.private.*.id
  tags = merge(
    { Name = "${var.vpc_name}-${each.value}-endpoint" },
    var.tags
  )
}

resource "aws_vpc_endpoint" "vpc_gatewayendpoint" {
  for_each            = toset(var.vpc_gatewayendpoints)
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  route_table_ids     = concat("${aws_route_table.private.*.id}","${aws_route_table.secure.*.id}")
  tags = merge(
    { Name = "${var.vpc_name}-${each.value}-endpoint" },
    var.tags
  )
}