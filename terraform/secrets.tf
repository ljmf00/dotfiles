data "infisical_secrets" "common_secrets" {
  env_slug     = "prod"
  workspace_id = "${var.infisical_project_id}"
  folder_path  = "/"
}
