variable "ami" {
  type = map(string)

  default = {
    "ap-south-1" = "ami-0620d12a9cf777c87"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "zone_a" {
  default = "ap-south-1a"
}

variable "zone_b" {
  default = "ap-south-1b"
}
/*
variable "dns_name" {
  default = "http://${aws_lb.internal.dns_name}:80/api/data.php"
}
*/