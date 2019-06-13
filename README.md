# terraform-aws-vpc
## Summary
This module deploys a 3 tier VPC. The following resources are managed:
- VPC
- Subnet
- Routes
- NACLs
- Internet Gateway
- NAT Gateway
- Virtual Private Gateway
- DHCP Option Sets

Tags on VPC/Subnets are currently set to ignore changes. This is to support EKS clusters.

Terraform >0.12 is required for this module.

## CIDR Calculations
CIDR ranges are automatically calculated using Terraforms cidrsubnet() function. The default configuration results in equal sized tiers that are -/2 (A /16 VPC becomes a /18 tier) smaller than the VPC. Subnets are calculated with tierCIDR-/2 (A /18 tier becomes /20 subnets). The number of subnets is determined by the number of `availability_zones` specified.

In the event you dont want this topology, you can configure the `x_tier_newbits` and `x_subnet_newbits` options found in the inputs.

The documentation for this function can be found [here](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html)

## Custom NACLs
NACL's in addition to the ones with input options can be added using the `nacl_x_custom` lists. The object schema is
```
list(object({
    rule_number = number,
    egress = bool,
    protocol = number,
    rule_action = string,
    cidr_block = string,
    from_port = string,
    to_port = string}))
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc_name | Name that will be prefixed to resources | string | n/a | yes |
| vpc_cidr_block | The CIDR block of the VPC | string | n/a | yes |
| vpc_enable_dns_support | Enable VPC DNS Resolver | bool | `true` | no |
| vpc_enable_dns_hostnames | Enable VPC DNS hostname resolution | bool | `true` | no |
| availability_zones | List of availability zones | list(string) | n/a | yes |
| public_tier_newbits | newbits value for calculating the public tier size | number | `2` | no |
| public_subnet_newbits | newbits value for calculating the public subnet size | number | `2` | no |
| private_tier_newbits | newbits value for calculating the private tier size | number | `2` | no |
| private_subnet_newbits | newbits value for calculating the private subnet size | number | `2` | no |
| secure_tier_newbits | newbits value for calculating the secure tier size | number | `2` | no |
| secure_subnet_newbits | newbits value for calculating the secure subnet size | number | `2` | no |
| enable_internet_gateway | Attach an internet gateway to the VPC | bool | `true` | no |
| enable_nat_gateway | Create nat gateways in the VPC | bool | `true` | no |
| enable_per_az_nat_gateway | Create 1 nat gateway per AZ | bool | `true` | no |
| enable_virtual_private_gateway | Attach a virtual private gateway to the VPC | bool | `false` | no |
| virtual_private_gateway_asn | ASN for the Amazon side of the VPG | number | 64512 | no |
| enable_custom_dhcp_options | Enable custom DHCP options, you must specify custom_dhcp_options | bool | `false` | no |
| custom_dhcp_options | Custom DHCP options | object({domain_name = string, domain_name_servers = list(string), ntp_servers = list(string), netbios_name_servers = list(string), netbios_node_type = number}) | `{domain_name = null domain_name_servers = null ntp_servers = null netbios_name_servers = null netbios_node_type = null}` | no |
| nacl_allow_all_vpc_traffic | Add a rule to all NACLs allowing all traffic to/from the vpc cidr | bool | `true` | no |
| nacl_allow_all_ephemeral | Add a rule to all NACLs allowing all ephemeral ports | bool | `true` | no |
| nacl_allow_all_http | Add a rule to all NACLs allowing http egress | bool | `true` | no |
| nacl_allow_all_https | Add a rule to all NACLs allowing https egress | bool | `true` | no |
| nacl_block_public_to_secure | Block all traffic between public and secure tiers | bool | `false` | no |
| nacl_public_custom | List of custom nacls to apply to the public tier | list(object({rule_number = number, egress = bool, protocol = number, rule_action = string, cidr_block = string, from_port = string, to_port = string})) | `null` | no |
| nacl_private_custom | List of custom nacls to apply to the private tier | list(object({rule_number = number, egress = bool, protocol = number, rule_action = string, cidr_block = string, from_port = string, to_port = string})) | `null` | no |
| nacl_secure_custom | List of custom nacls to apply to the secure tier | list(object({rule_number = number, egress = bool, protocol = number, rule_action = string, cidr_block = string, from_port = string, to_port = string})) | `null` | no |
| tags | Tags applied to all resources | map(string) | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| public_tier_subnet | Calculated CIDR range of the public tier |
| private_tier_subnet | Calculated CIDR range of the private tier |
| secure_tier_subnet | Calculated CIDR range of the secure tier |

## Development
Most of the terraform ecosystem doesnt yet support 0.12. You need to manually update Inputs/Outputs when you add variables until terraform-docs supports 0.12.
