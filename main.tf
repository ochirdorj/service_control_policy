# Retrieve organization data
data "aws_organizations_organization" "org" {}

# Retrieve OUs under root
data "aws_organizations_organizational_units" "root_children" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

locals {
  # Root ID
  root_id = data.aws_organizations_organization.org.roots[0].id

  # Filter OUs by provided names
  target_ou_ids = [
    for ou in data.aws_organizations_organizational_units.root_children.children : ou.id
    if contains(var.target_ou_names, try(ou.name, ""))
  ]

  # Filter accounts by provided names
  target_account_ids = [
    for acct in data.aws_organizations_organization.org.accounts : acct.id
    if contains(var.target_account_names, try(acct.name, ""))
  ]

  # Optionally include root
  target_root_ids = var.include_root ? [local.root_id] : []

  # Merge all targets
  all_target_ids = concat(
    local.target_ou_ids,
    local.target_account_ids,
    local.target_root_ids
  )
}

# Create SCP policy
resource "aws_organizations_policy" "scp_policy" {
  name        = var.scp_name
  description = var.scp_description
  content     = file(var.scp_path)  
  type        = var.scp_type
}

# Attach SCP to all targets
resource "aws_organizations_policy_attachment" "attachments" {
  for_each = toset(local.all_target_ids)

  policy_id = aws_organizations_policy.scp_policy.id
  target_id = each.value
}