variable "zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
  validation {
    condition     = length(var.zone_id) > 0
    error_message = "zone_id must not be empty."
  }
}

variable "record_name" {
  description = "DNS record name"
  type        = string
  validation {
    condition     = length(var.record_name) > 0
    error_message = "record_name must not be empty."
  }
}

variable "record_type" {
  description = "DNS record type (A, AAAA, CNAME, MX, TXT, etc.)"
  type        = string
  validation {
    condition     = contains(["A", "AAAA", "CNAME", "MX", "TXT", "NS", "SOA", "SRV", "PTR", "CAA"], var.record_type)
    error_message = "record_type must be a valid DNS record type."
  }
}

variable "ttl" {
  description = "TTL in seconds (not used with alias records)"
  type        = number
  default     = 300
}

variable "records" {
  description = "List of record values (not used with alias records)"
  type        = list(string)
  default     = null
}

variable "alias_name" {
  description = "DNS name for alias record (e.g., CloudFront domain)"
  type        = string
  default     = null
}

variable "alias_zone_id" {
  description = "Hosted zone ID for alias target"
  type        = string
  default     = null
}

variable "evaluate_target_health" {
  description = "Whether to evaluate target health for alias"
  type        = bool
  default     = false
}
