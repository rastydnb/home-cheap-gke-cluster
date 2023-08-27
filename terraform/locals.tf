locals {
  secrets_map = [
    {
      name               = "demo-password-1"
      autogenerate       = true
      chars_count        = 24
      use_special_charts = false
    },
    {
      name               = "weave-gitops-admin"
      autogenerate       = false
      chars_count        = 32
      use_special_charts = false
      secret_value = "$2a$10$TfDPDXkXsgRmGYIUTGyUB.l0qh3ODA2qUa/ZPRaThoawHkB5/iD32"
    }
  ]
}



