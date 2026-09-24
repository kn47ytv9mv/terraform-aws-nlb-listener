resource "aws_lb_listener" "resource" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.protocol == "TLS" ? var.ssl_policy : null
  certificate_arn   = var.certificate_arn
  alpn_policy       = var.protocol == "TLS" ? var.alpn_policy : null

  tags = var.tags

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}

output "id" {
  description = "The ID of the listener."
  value       = aws_lb_listener.resource.id
}

output "arn" {
  description = "The ARN of the listener."
  value       = aws_lb_listener.resource.arn
}
