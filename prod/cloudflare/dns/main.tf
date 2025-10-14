variable "cloudflare_zone_id" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "dns_records" {
  type = list(object({
    type = string
    subdomains = list(string)
    content = string
    proxied = optional(bool, false)
    ttl = optional(number, 1)
  }))
}

locals {
  records = {
    for r in flatten([for record in var.dns_records : [for subdomain in record.subdomains : merge(record, { subdomain = subdomain })]]) : r.subdomain => r
  }
}

resource "cloudflare_dns_record" "main" {
  for_each = local.records
  name     = "${each.value.subdomain}.${var.zone_name}"
  zone_id  = var.cloudflare_zone_id
  type     = each.value.type
  content  = each.value.content
  proxied  = each.value.proxied
  ttl      = each.value.proxied ? 1 : each.value.ttl
}
