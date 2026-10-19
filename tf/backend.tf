# HTTP Backend for Terraform State
#
# Persistent state storage on runner VM's terraform-backend service.
# URL configuration via TF_HTTP_* environment variables (set in workflow).
#
# Username MUST be "basic" (selects auth backend type in nimbolus/terraform-backend).

terraform {
  backend "http" {}
}
