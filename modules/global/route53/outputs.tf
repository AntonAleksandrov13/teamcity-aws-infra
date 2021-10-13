output "txt_owner_id" {
  value = module.zones.route53_zone_zone_id[keys(module.zones.route53_zone_zone_id)[0]]
}
