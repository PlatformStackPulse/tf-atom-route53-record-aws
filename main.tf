resource "aws_route53_record" "this" {
  count = module.this.enabled ? 1 : 0

  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type
  ttl     = var.alias_name == null ? var.ttl : null
  records = var.alias_name == null ? var.records : null

  dynamic "alias" {
    for_each = var.alias_name != null ? [1] : []
    content {
      name                   = var.alias_name
      zone_id                = var.alias_zone_id
      evaluate_target_health = var.evaluate_target_health
    }
  }
}
