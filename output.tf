output "external_dns" {
  value = aws_lb.external.dns_name
}

output "internal_dns" {
  value = aws_lb.internal.dns_name
}

output "front_1_ip" {
  value = aws_instance.front-1.public_ip
}

output "front_2_ip" {
  value = aws_instance.front-2.public_ip
}

output "back_1_ip" {
  value = aws_instance.back-1.public_ip
}

output "back_2_ip" {
  value = aws_instance.back-2.public_ip
}
