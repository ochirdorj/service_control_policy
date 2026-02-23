module "scp" {
  source = "github.com/aKumoProject-13/pac-service-contol-policy//modules?ref=feature/ec2_tag_policy"

  ##Input variables##
  scp_name = "EnforceEC2Tag"
  scp_description = "SCP to enforce Ec2 instance tag"
  scp_json_path = file("../policies/ec2_tag_policy.json")
  scp_type = "SERVICE_CONTROL_POLICY"
  include_root = false
  target_ou_names = ["Infra", "TechFleet"]
  target_account_names = []
}