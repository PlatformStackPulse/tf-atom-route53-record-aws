output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "fqdn" {
  description = "FQDN of the record"
  value       = try(aws_route53_record.this[0].fqdn, aws_route53_record.alias[0].fqdn, null)
}

output "name" {
  description = "Name of the record"
  value       = try(aws_route53_record.this[0].name, aws_route53_record.alias[0].name, null)
}
