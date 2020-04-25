resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = file("terraform-demo.pub")
}

resource "aws_instance" "front-1" {
  ami                         = var.ami[var.aws_region]
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform-demo.key_name
  availability_zone           = var.zone_a
  subnet_id                   = aws_subnet.front_1.id
  security_groups             = [aws_security_group.frontEnd.id]
  user_data                   = <<-EOT
                            #!/bin/bash
                            apt -y update
                            apt install -y apache2
                            apt install -y php7.2 
                            apt install -y php7.2-curl
                            touch /var/www/html/data.php
                                    ## adding php script to fetch from private subnet
                            echo "Writing php file"
                            echo "<h3> Creating a connection from Server 1 </h3> " > /var/www/html/data.php
                            echo "<?php " >> /var/www/html/data.php
                            echo '$url = "http://${aws_lb.internal.dns_name}:80/api/data.php"; ' >> /var/www/html/data.php
                            echo "\$client = curl_init(\$url); " >> /var/www/html/data.php
                            echo "curl_setopt(\$client, CURLOPT_RETURNTRANSFER,true); " >> /var/www/html/data.php
                            echo "\$response = curl_exec(\$client); " >> /var/www/html/data.php
                            echo "echo \$response ; " >> /var/www/html/data.php
                            echo "curl_close(\$client); " >> /var/www/html/data.php
                            echo "?> " >> /var/www/html/data.php
                            echo "Done writing php file"
                                    # changes made in php.ini file to run curl command
                            systemctl start apache2
                            echo "extension=curl" >> /etc/php/7.2/apache2/php.ini
                            echo "display_errors=On" >> /etc/php/7.2/apache2/php.ini
                            echo "error_reporting=E_ALL" >> /etc/php/7.2/apache2/php.ini
                            echo "changes in php.ini done"
                                        ## starting apache2 service
                            systemctl restart apache2
                            EOT
  associate_public_ip_address = "true"
}

resource "aws_instance" "front-2" {
  ami                         = var.ami[var.aws_region]
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform-demo.key_name
  availability_zone           = var.zone_b
  subnet_id                   = aws_subnet.front_2.id
  security_groups             = [aws_security_group.frontEnd.id]
  user_data                   =  <<-EOT
                            #!/bin/bash
                            apt -y update
                            apt install -y apache2
                            apt install -y php7.2 
                            apt install -y php7.2-curl
                            touch /var/www/html/data.php
                                    ## adding php script to fetch from private subnet
                            echo "Writing php file"
                            echo "<h3> Creating a connection from Server 2 </h3> " > /var/www/html/data.php
                            echo "<?php " >> /var/www/html/data.php
                            echo '$url = "http://${aws_lb.internal.dns_name}:80/api/data.php"; ' >> /var/www/html/data.php
                            echo "\$client = curl_init(\$url); " >> /var/www/html/data.php
                            echo "curl_setopt(\$client, CURLOPT_RETURNTRANSFER,true); " >> /var/www/html/data.php
                            echo "\$response = curl_exec(\$client); " >> /var/www/html/data.php
                            echo "echo \$response ; " >> /var/www/html/data.php
                            echo "curl_close(\$client); " >> /var/www/html/data.php
                            echo "?> " >> /var/www/html/data.php
                            echo "Done writing php file"
                                    # changes made in php.ini file to run curl command
                            systemctl start apache2
                            echo "extension=curl" >> /etc/php/7.2/apache2/php.ini
                            echo "display_errors=On" >> /etc/php/7.2/apache2/php.ini
                            echo "error_reporting=E_ALL" >> /etc/php/7.2/apache2/php.ini
                            echo "changes in php.ini done"
                                        ## starting apache2 service
                            systemctl restart apache2
                            EOT
  associate_public_ip_address = "true"
}

resource "aws_instance" "back-2" {
  ami                         = var.ami[var.aws_region]
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform-demo.key_name
  availability_zone           = var.zone_b
  subnet_id                   = aws_subnet.back_2.id
  security_groups             = [aws_security_group.backEnd.id]
  user_data                   = file("user_data_private_instance_2.sh")
  associate_public_ip_address = "true"
}

resource "aws_instance" "back-1" {
  ami                         = var.ami[var.aws_region]
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform-demo.key_name
  availability_zone           = var.zone_a
  subnet_id                   = aws_subnet.back_1.id
  security_groups             = [aws_security_group.backEnd.id]
  user_data                   = file("user_data_private_instance_1.sh")
  associate_public_ip_address = "true"
}