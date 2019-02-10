provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

#create an EC2 instance
resource "aws_instance" "AmazonLinux1" {
  #ami = "${var.aws_amis}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id  = "${var.aws_subnet}"
  connection {
    # The default username for our AMI
    user = "ec2-user"
    private_key = "${file("/Users/*/Downloads/*.pem")}"

  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, w By default,
  # this should be on port 80
  # mount the already created CVS volume

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash\n",
      "sudo yum update -y aws-cfn-bootstrap\n",
      "sudo yum install -y nfs-utils\n",
      "#Creating new directory\n",
      "sudo mkdir terraform\n",
      "#Permissions for the Direcotry\n",
      "sudo chmod -R 755 terraform",
      "# mount ontap Volumes\n",
      "sudo mount -t nfs -o rw,hard,nointr,rsize=32768,wsize=32768,bg,nfsvers=3,tcp 172.16.51.84:/terraformDemoVolume terraform"
      #"sudo mount -t nfs -o rw,hard,nointr,rsize=32768,wsize=32768,bg,nfsvers=3,tcp 172.16.55.148:/adoring-ubiquitous-morse terraform"
    ]
  }
}



