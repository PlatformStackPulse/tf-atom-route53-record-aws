resource "aws_route53_record" "this" {
  count = module.this.enabled && !var.is_alias ? 1 : 0

  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type
  ttl     = var.ttl
  records = var.records
}

resource "aws_route53_record" "alias" {
  count = module.this.enabled && var.is_alias ? 1 : 0

  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
