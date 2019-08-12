variable "vpc_name" {
  type        = string
  description = "Name that will be prefixed to resources"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block of the VPC"
}

variable "vpc_enable_dns_support" {
  type        = bool
  description = "Enable VPC DNS resolver"
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "Enable VPC DNS hostname resolution"
  default     = true
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_tier_newbits" {
  type        = number
  description = "newbits value for calculating the public tier size"
  default     = 2
}

variable "public_subnet_newbits" {
  type        = number
  description = "newbits value for calculating the public subnet size"
  default     = 2
}

variable "private_tier_newbits" {
  type        = number
  description = "newbits value for calculating the private tier size"
  default     = 2
}

variable "private_subnet_newbits" {
  type        = number
  description = "newbits value for calculating the private subnet size"
  default     = 2
}

variable "secure_tier_newbits" {
  type        = number
  description = "newbits value for calculating the secure tier size"
  default     = 2
}

variable "secure_subnet_newbits" {
  type        = number
  description = "newbits value for calculating the secure subnet size"
  default     = 2
}

variable "enable_internet_gateway" {
  type        = bool
  description = "Attach an internet gateway to the VPC"
  default     = true
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create nat gateways in the VPC,"
  default     = true
}

variable "enable_per_az_nat_gateway" {
  type        = bool
  description = "Create 1 nat gateway per AZ"
  default     = true
}

variable "enable_virtual_private_gateway" {
  type        = bool
  description = "Attach a virtual private gateway to the VPC"
  default     = false
}

variable "virtual_private_gateway_asn" {
  type        = number
  description = "ASN for the Amazon side of the VPG"
  default     = 64512
}

variable "enable_custom_dhcp_options" {
  type        = bool
  description = "Enable custom DHCP options, you must specify custom_dhcp_options"
  default     = false
}

variable "custom_dhcp_options" {
  type = object({
    domain_name          = string,
    domain_name_servers  = list(string),
    ntp_servers          = list(string),
    netbios_name_servers = list(string),
    netbios_node_type    = number
  })
  description = "Custom DHCP options"
  default = {
    domain_name          = null
    domain_name_servers  = null
    ntp_servers          = null
    netbios_name_servers = null
    netbios_node_type    = null
  }
}

variable "nacl_allow_all_vpc_traffic" {
  type        = bool
  description = "Add a rule to all NACLs allowing all traffic to/from the vpc cidr"
  default     = true
}

variable "nacl_allow_all_ephemeral" {
  type        = bool
  description = "Add a rule to all NACLs allowing all ephemeral ports"
  default     = true
}

variable "nacl_allow_all_http" {
  type        = bool
  description = "Add a rule to all NACLs allowing http egress"
  default     = true
}

variable "nacl_allow_all_https" {
  type        = bool
  description = "Add a rule to all NACLs allowing https egress"
  default     = true
}

variable "nacl_block_public_to_secure" {
  type        = bool
  description = "Block all traffic between public and secure tiers"
  default     = false
}

variable "nacl_public_custom" {
  type = list(object({
    rule_number = number,
    egress      = bool,
    protocol    = any, // can be "tcp" or 6
    rule_action = string,
    cidr_block  = string,
    from_port   = string,
    to_port     = string
  }))
  description = "List of custom nacls to apply to the public tier"
  default     = null
}

variable "nacl_private_custom" {
  type = list(object({
    rule_number = number,
    egress      = bool,
    protocol    = any,
    rule_action = string,
    cidr_block  = string,
    from_port   = string,
    to_port     = string
  }))
  description = "List of custom nacls to apply to the private tier"
  default     = null
}

variable "nacl_secure_custom" {
  type = list(object({
    rule_number = number,
    egress      = bool,
    protocol    = any,
    rule_action = string,
    cidr_block  = string,
    from_port   = string,
    to_port     = string
  }))
  description = "List of custom nacls to apply to the secure tier"
  default     = null
}


variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
  default     = {}
}
