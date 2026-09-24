# terraform-aws-nlb-listener

Terraform module for a single Network Load Balancer listener.

## Cost

A listener has no charge of its own — it is billed as part of the
Network Load Balancer Capacity Units its load balancer consumes. See
[`terraform-aws-nlb`](https://github.com/kn47ytv9mv/terraform-aws-nlb)'s
Cost section for where that charge originates.

## Design

Always forwards — unlike
[`terraform-aws-alb-listener`](https://github.com/kn47ytv9mv/terraform-aws-alb-listener)'s
`type`/`redirect` pair, a Network Load Balancer listener has no
redirect or fixed-response action at the TCP/UDP layer, so this module
takes `target_group_arn` directly rather than a discriminated action
shape.

`ssl_policy` and `alpn_policy` are only ever sent to AWS for a `"TLS"`
listener — both are `null`ed out for any other protocol, which AWS
rejects them for if set, the same pattern as
`terraform-aws-alb-listener`'s `ssl_policy` handling.

## Usage

```hcl
module "listener" {
  source = "kn47ytv9mv/nlb-listener/aws"

  load_balancer_arn = module.nlb.arn
  port              = 443
  target_group_arn  = module.target_group.arn
}
```

Or directly from this repository, a TLS listener terminating
encryption at the load balancer:

```hcl
module "listener" {
  source = "github.com/kn47ytv9mv/terraform-aws-nlb-listener"

  load_balancer_arn = module.nlb.arn
  port              = 443
  protocol          = "TLS"
  certificate_arn   = module.certificate.arn
  target_group_arn  = module.target_group.arn
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.0 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| load_balancer_arn | The ARN of the load balancer this listener is attached to. | `null` | no |
| port | Port the listener listens on. | `null` | no |
| protocol | Protocol the listener listens with ('TCP', 'UDP', 'TCP_UDP', or 'TLS'). | `"TCP"` | no |
| target_group_arn | The ARN of the target group this listener forwards all traffic to. A Network Load Balancer listener has no other action type — there is no redirect or fixed-response equivalent at the TCP/UDP layer. | `null` | no |
| ssl_policy | SSL policy for a TLS listener. Never sent to AWS for any other protocol, which rejects it if set. | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| certificate_arn | The ARN of the default ACM certificate for a TLS listener. | `null` | no |
| alpn_policy | ALPN policy for a TLS listener, controlling which application protocol is negotiated (e.g. 'HTTP2Preferred'). Not used for any other protocol. | `null` | no |
| tags | A map of tags to assign to the listener. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the listener. |
| arn | The ARN of the listener. |

## License

MIT — see [LICENSE.md](LICENSE.md).
