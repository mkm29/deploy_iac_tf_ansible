# Private key values
output "MasterPrivateKey" {
  value = tls_private_key.ssh_key.private_key_pem
}
## Need to write pem file to disk
#
# `terraform output MasterPrivateKey > id_rsa.pem`
# `ssh -i id_rsa.pem ec2-user@$(terraform output Jenkins-Main-Node-Public-IP)`
#
#################################


###This chunk of template can also be put inside outputs.tf for better segregation 
output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}

output "Jenkins-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.jenkins-worker-ohio :
    instance.id => instance.public_ip
  }
}
