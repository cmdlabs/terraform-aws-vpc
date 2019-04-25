resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  subnet_ids = aws_subnet.private.*.id

  tags = merge(
    { Name = "${var.vpc_name}-private" },
    var.tags
  )
}

resource "aws_network_acl_rule" "private_all_vpc_traffic_ingress" {
  count = var.nacl_allow_all_vpc_traffic ? 1 : 0

  network_acl_id = aws_network_acl.private.id

  rule_number = 651
  egress = false
  protocol = -1
  rule_action = "allow"
  cidr_block = var.vpc_cidr_block
}

resource "aws_network_acl_rule" "private_all_vpc_traffic_egress" {
  count = var.nacl_allow_all_vpc_traffic ? 1 : 0

  network_acl_id = aws_network_acl.private.id

  rule_number = 651
  egress = true
  protocol = -1
  rule_action = "allow"
  cidr_block = var.vpc_cidr_block
}

resource "aws_network_acl_rule" "private_all_ephemeral_tcp_ingress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.private.id

  rule_number = 2051
  egress = false
  protocol = 6
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "private_all_ephemeral_tcp_egress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.private.id

  rule_number = 2051
  egress = true
  protocol = 6
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "private_all_ephemeral_udp_ingress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.private.id

  rule_number = 2052
  egress = false
  protocol = 17
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "private_all_ephemeral_udp_egress" {
  count = var.nacl_allow_all_ephemeral ? 1 : 0

  network_acl_id = aws_network_acl.private.id

  rule_number = 2052
  egress = true
  protocol = 17
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "private_custom" {
  count = var.nacl_allow_private_custom != null ? length(var.nacl_allow_private_custom) : 0

  network_acl_id = aws_network_acl.private.id

  rule_number = var.nacl_allow_private_custom[count.index].rule_number
  egress = var.nacl_allow_private_custom[count.index].egress
  protocol = var.nacl_allow_private_custom[count.index].protocol
  rule_action = var.nacl_allow_private_custom[count.index].rule_action
  cidr_block = var.nacl_allow_private_custom[count.index].cidr_block
  from_port = var.nacl_allow_private_custom[count.index].from_port
  to_port = var.nacl_allow_private_custom[count.index].to_port
}
