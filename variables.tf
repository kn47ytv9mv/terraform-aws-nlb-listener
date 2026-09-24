variable "load_balancer_arn" {
  default     = null
  description = "The ARN of the load balancer this listener is attached to."
}

variable "port" {
  default     = null
  description = "Port the listener listens on."
}

variable "protocol" {
  default     = "TCP"
  description = "Protocol the listener listens with ('TCP', 'UDP', 'TCP_UDP', or 'TLS')."
}

variable "target_group_arn" {
  default     = null
  description = "The ARN of the target group this listener forwards all traffic to. A Network Load Balancer listener has no other action type — there is no redirect or fixed-response equivalent at the TCP/UDP layer."
}

variable "ssl_policy" {
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "SSL policy for a TLS listener. Never sent to AWS for any other protocol, which rejects it if set."
}

variable "certificate_arn" {
  default     = null
  description = "The ARN of the default ACM certificate for a TLS listener."
}

variable "alpn_policy" {
  default     = null
  description = "ALPN policy for a TLS listener, controlling which application protocol is negotiated (e.g. 'HTTP2Preferred'). Not used for any other protocol."
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the listener."
}
