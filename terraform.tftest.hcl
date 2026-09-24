mock_provider "aws" {
}

run "tcp_listener_omits_tls_only_fields" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example/50dc6c495c0c9188"
    port              = 443
    target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/73e2d6bc24d8a067"
  }

  assert {
    condition     = aws_lb_listener.resource.protocol == "TCP"
    error_message = "protocol should default to 'TCP'."
  }

  assert {
    condition     = aws_lb_listener.resource.default_action[0].type == "forward"
    error_message = "default_action.type should always be 'forward' — a Network Load Balancer listener has no redirect action."
  }

  assert {
    condition     = aws_lb_listener.resource.default_action[0].target_group_arn == "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/73e2d6bc24d8a067"
    error_message = "target_group_arn should pass through unchanged."
  }
}

run "tls_listener_sends_ssl_policy_and_certificate" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example/50dc6c495c0c9188"
    port              = 443
    protocol          = "TLS"
    certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"
    target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/73e2d6bc24d8a067"
  }

  assert {
    condition     = aws_lb_listener.resource.ssl_policy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    error_message = "A TLS listener should send the default ssl_policy."
  }

  assert {
    condition     = aws_lb_listener.resource.certificate_arn == "arn:aws:acm:us-east-1:123456789012:certificate/abc123"
    error_message = "certificate_arn should pass through unchanged."
  }
}

run "alpn_policy_only_sent_for_tls" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example/50dc6c495c0c9188"
    port              = 443
    alpn_policy       = "HTTP2Preferred"
    target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/73e2d6bc24d8a067"
  }

  assert {
    condition     = aws_lb_listener.resource.alpn_policy == null
    error_message = "alpn_policy should never be sent for a non-TLS protocol, even if given."
  }
}

run "readme_tcp_example" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example/50dc6c495c0c9188"
    port              = 443
    target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/73e2d6bc24d8a067"
  }
}

run "readme_tls_example" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example/50dc6c495c0c9188"
    port              = 443
    protocol          = "TLS"
    certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"
    target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/73e2d6bc24d8a067"
  }
}
