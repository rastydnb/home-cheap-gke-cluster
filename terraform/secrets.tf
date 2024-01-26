module "secrets" {
  count               = length(var.secrets_map)
  source              = "./modules/backend_dynamic_secrets"
  gcp_project_id      = var.project_id
  name                = lookup(var.secrets_map[count.index], "name")
  autogenerate_secert = lookup(var.secrets_map[count.index], "autogenerate")
  use_special_chars   = lookup(var.secrets_map[count.index], "use_special_chars", false)
  chars_count         = lookup(var.secrets_map[count.index], "chars_count")
  secret_value        = lookup(var.secrets_map[count.index], "secret_value", "")
}

module "iam" {
    source              = "./modules/iam"
    project_id          = var.project_id
}