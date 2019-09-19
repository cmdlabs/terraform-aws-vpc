resource "aws_route_table" "private" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.main.id

  propagating_vgws = var.enable_virtual_private_gateway ? aws_vpn_gateway.main.*.id : []

  tags = merge(
    { Name = "${var.vpc_name}-private-${local.count_to_alpha[count.index]}" },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "private_default" {
  count = var.enable_nat_gateway ? length(var.availability_zones) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.enable_per_az_nat_gateway ? aws_nat_gateway.main[count.index].id : aws_nat_gateway.main[0].id
}
