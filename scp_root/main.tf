module "scp" {
  source = "../modules"

  ##Input variables##
  scp_name = "block marketplace ami except ss and dev accounts"
  scp_description = "This policy is going to block all marketplace AMIs except ss and dev accounts"
  scp_json_path = file("policies/block_mp_ami.json")
  scp_type = "SERVICE_CONTROL_POLICY"
  include_root = false
  target_ou_names = ["Security"]
  target_account_names = ["DNS", "Production", "Test"]
}


