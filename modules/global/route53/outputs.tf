#TODO: look into a different way of getting zone id
output "txt_owner_id" {
  value = module.zones.route53_zone_zone_id[keys(module.zones.route53_zone_zone_id)[0]]
}
