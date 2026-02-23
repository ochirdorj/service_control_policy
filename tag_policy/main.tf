module "scp" {
  source = "../modules"

  ##Input variables##
  scp_name = "EnforceTag"
  scp_description = "SCP to enforce resource tag"
  scp_json_path = file("../policies/tag_enforce_policy.json")
  scp_type = "SERVICE_CONTROL_POLICY"
  include_root = false
  target_ou_names = ["Infra", "TechFleet"]
  target_account_names = []
}
