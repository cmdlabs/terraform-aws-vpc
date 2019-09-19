resource "aws_route_table" "public" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.main.id

  propagating_vgws = var.enable_virtual_private_gateway ? aws_vpn_gateway.main.*.id : []

  tags = merge(
    { Name = "${var.vpc_name}-public-${local.count_to_alpha[count.index]}" },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route" "public_default" {
  count = var.enable_internet_gateway ? length(var.availability_zones) : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main[0].id
}
