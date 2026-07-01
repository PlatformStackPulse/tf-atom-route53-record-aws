# Unit Tests for tf-atom-route53-record-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# Assertions target plan-KNOWN values only (module enabled flag, resource
# counts). Computed attributes such as fqdn/name/arn are unknown under a
# mock provider and must not be asserted on.

mock_provider "aws" {}

variables {
  # tf-label context inputs
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-specific required inputs
  zone_id     = "Z1234567890ABCDEFGHIJ"
  record_name = "app.example.com"
  record_type = "A"
  ttl         = 300
  records     = ["192.0.2.1"]
}

# ---------------------------------------------------------------------------
# Test: standard (non-alias) record is created when the module is enabled
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should report enabled == true when enabled input defaults to true"
  }

  assert {
    condition     = length(aws_route53_record.this) == 1
    error_message = "Exactly one standard route53 record should be planned when enabled and not an alias"
  }

  assert {
    condition     = length(aws_route53_record.alias) == 0
    error_message = "No alias record should be planned when is_alias is false"
  }
}

# ---------------------------------------------------------------------------
# Test: alias record path is selected when is_alias = true
# ---------------------------------------------------------------------------
run "creates_alias_when_is_alias" {
  command = plan

  variables {
    is_alias      = true
    alias_name    = "d111111abcdef8.cloudfront.net"
    alias_zone_id = "Z2FDTNDATAQYW2"
    records       = null
  }

  assert {
    condition     = length(aws_route53_record.alias) == 1
    error_message = "Exactly one alias record should be planned when is_alias is true"
  }

  assert {
    condition     = length(aws_route53_record.this) == 0
    error_message = "No standard record should be planned when is_alias is true"
  }
}

# ---------------------------------------------------------------------------
# Test: disabled module creates nothing and outputs null
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "Module should report enabled == false when enabled input is false"
  }

  assert {
    condition     = length(aws_route53_record.this) == 0
    error_message = "No standard record should be planned when the module is disabled"
  }

  assert {
    condition     = length(aws_route53_record.alias) == 0
    error_message = "No alias record should be planned when the module is disabled"
  }

  assert {
    condition     = output.fqdn == null
    error_message = "fqdn output should be null when the module is disabled"
  }
}
