resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "main" {
  count = var.enable_internet_gateway ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )
}

resource "aws_vpn_gateway" "main" {
  count = var.enable_virtual_private_gateway ? 1 : 0

  vpc_id          = aws_vpc.main.id
  amazon_side_asn = var.virtual_private_gateway_asn

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )
}

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.enable_per_az_nat_gateway ? length(var.availability_zones) : 1) : 0

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.main[count.index].id

  tags = merge(
    { Name = "${var.vpc_name}-${local.count_to_alpha[count.index]}" },
    var.tags
  )
}

resource "aws_eip" "main" {
  count = var.enable_nat_gateway ? (var.enable_per_az_nat_gateway ? length(var.availability_zones) : 1) : 0

  vpc = true

  tags = merge(
    { Name = "${var.vpc_name}-nat-${local.count_to_alpha[count.index]}" },
    var.tags
  )
}
