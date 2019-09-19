resource "aws_vpc_dhcp_options" "main" {
  count = var.enable_custom_dhcp_options ? 1 : 0

  domain_name          = var.custom_dhcp_options["domain_name"]
  domain_name_servers  = var.custom_dhcp_options["domain_name_servers"]
  ntp_servers          = var.custom_dhcp_options["ntp_servers"]
  netbios_name_servers = var.custom_dhcp_options["netbios_name_servers"]
  netbios_node_type    = var.custom_dhcp_options["netbios_node_type"]

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )
}
