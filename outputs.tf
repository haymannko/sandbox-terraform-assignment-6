
output "ssh_command" {
    value = "ssh -i ${local_file.private_key.filename} ${lookup(local.ssh_username,local.selected_ami,"No Need")}@${aws_eip.public_eip.public_ip}"
}