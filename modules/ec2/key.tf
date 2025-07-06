resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "./.ssh/terraform_rsa"
  file_permission = "0400"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "./.ssh/terraform_rsa.pub"

}


resource "aws_key_pair" "deployer" {
  key_name   = format("%s-ssh-key", var.instance_name)
  public_key = tls_private_key.ssh_key.public_key_openssh
}
