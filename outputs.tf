

output "my_zones" {
    value = data.aws_availability_zones.available.names
  
}

output "vpc_name1" {
    value = "My public VPC name is ${aws_vpc.peering_vpc1.tags.Name}"
  
}

output "vpc_name2" {
    value = "My private VPC name is ${aws_vpc.peering_vpc2.tags.Name}"
  
}

output "igw_name" {
    value = "My IGW name is ${aws_internet_gateway.IGW.tags.Name}"
  
}



output "ssh_command" {
    value = "ssh -i ${local_file.private_key.filename} ${lookup(local.ssh_username,local.selected_ami,"No Need")}@${aws_eip.public_eip.public_ip}"
}