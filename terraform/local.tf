locals {
  environment = "dev"
  application = "todo"
  location    = "central india"
  name_prefix = "${local.environment}-${local.application}-${local.location}"

  common_tags = {
    "environment" = local.environment
    "owner"       = "devops-team"
    "project"     = "devops-practice"
    "application" = local.application
  }
}
