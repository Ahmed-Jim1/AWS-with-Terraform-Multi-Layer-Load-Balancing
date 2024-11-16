resource "aws_instance" "pub-ec2" {
  count                       = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public-subnet_id[count.index]
  security_groups             = [var.public-ec2_sg_id]
  associate_public_ip_address = true
  tags = {
      Name = "web-ec2_${count.index+1}"
    } 

    user_data = <<EOF
LB_DNS="${var.lb-backend_dns_name}"
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo cat > /etc/nginx/sites-enabled/default << EOL
server {
    listen 80 default_server;
    location / {
      proxy_pass http://$LB_DNS;
    }
}
  
EOL
sudo systemctl restart nginx
EOF

  provisioner "local-exec" {
    when        = create
    on_failure  = continue
    command = "echo public-ip-${count.index} : ${self.private_ip} >> all-ips.txt"
 }
}




resource "aws_instance" "priv-ec2" {
  count                       = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.private-subnet_id[count.index]
  security_groups             = [var.private-ec2_sg_id] 
  associate_public_ip_address = false
  
  tags = {
    Name = "backend_ec2_${count.index+1}"  
  }
   user_data =  <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo '<html><body><h1>Hello from Server ${count.index + 1 } </h1></body></html>' | sudo tee /var/www/html/index.html
  sudo systemctl restart httpd
  EOF

  provisioner "local-exec" {
    when        = create
    on_failure  = continue
    command = "echo private-ip-${count.index} : ${self.private_ip} >> all-ips.txt"
 }
} 
