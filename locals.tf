
locals {
    vpc_name1 = aws_vpc.peering_vpc1.tags.Name
    vpc_name2 = aws_vpc.peering_vpc2.tags.Name
}