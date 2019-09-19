resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  subnet_ids = aws_subnet.public.*.id

  tags = merge(
    { Name = "${var.vpc_name}-public" },
    var.tags
  )
}

resource "aws_network_acl_rule" "public_all_vpc_traffic_ingress" {
  count = var.nacl_allow_all_vpc_traffic ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 651
  egress      = false
  protocol    = -1
  rule_action = "allow"
  cidr_block  = var.vpc_cidr_block
}

resource "aws_network_acl_rule" "public_all_vpc_traffic_egress" {
  count = var.nacl_allow_all_vpc_traffic ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 651
  egress      = true
  protocol    = -1
  rule_action = "allow"
  cidr_block  = var.vpc_cidr_block
}

resource "aws_network_acl_rule" "public_all_ephemeral_tcp_ingress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 2051
  egress      = false
  protocol    = 6
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 1024
  to_port     = 65535
}

resource "aws_network_acl_rule" "public_all_ephemeral_tcp_egress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 2051
  egress      = true
  protocol    = 6
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 1024
  to_port     = 65535
}

resource "aws_network_acl_rule" "public_all_ephemeral_udp_ingress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 2052
  egress      = false
  protocol    = 17
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 1024
  to_port     = 65535
}

resource "aws_network_acl_rule" "public_all_ephemeral_udp_egress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 2052
  egress      = true
  protocol    = 17
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 1024
  to_port     = 65535
}

resource "aws_network_acl_rule" "public_custom" {
  count = var.nacl_public_custom != null ? length(var.nacl_public_custom) : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = var.nacl_public_custom[count.index].rule_number
  egress      = var.nacl_public_custom[count.index].egress
  protocol    = var.nacl_public_custom[count.index].protocol
  rule_action = var.nacl_public_custom[count.index].rule_action
  cidr_block  = var.nacl_public_custom[count.index].cidr_block
  from_port   = var.nacl_public_custom[count.index].from_port
  to_port     = var.nacl_public_custom[count.index].to_port
}

resource "aws_network_acl_rule" "public_allow_http_egress" {
  count = var.nacl_allow_all_http ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 1950
  egress      = true
  protocol    = 6
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
}

resource "aws_network_acl_rule" "public_allow_https_egress" {
  count = var.nacl_allow_all_https ? 1 : 0

  network_acl_id = aws_network_acl.public.id

  rule_number = 1951
  egress      = true
  protocol    = 6
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
}
