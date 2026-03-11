#This code will retreive important data of organization such as id, arn, list of OUs and account
data "aws_organizations_organization" "org" {}

# This code will retreive all information of OUs under root such as arn, id, parent id of ou and accounts
data "aws_organizations_organizational_units" "root_children" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

#Retrieval of root id
locals {
  root_id = data.aws_organizations_organization.org.roots[0].id
}

#This code will choose and list OU ids from all ou ids which I would like to attach SCP. I provided the names of OU in input variable.
locals {
  target_ou_ids = [
    for ou in data.aws_organizations_organizational_units.root_children.children : ou.id
    if contains(var.target_ou_names, try(ou.name, ""))
  ]
}

#This code will choose account ids from all account ids which I would like to attach SCP. I provided the names of account in input variable.
locals {
  target_account_ids = [
    for acct in data.aws_organizations_organization.org.accounts : acct.id 
    if contains(var.target_account_names, try(acct.name, ""))
  ]
}

#This code will decide whether we include the policy application to the root of organization
locals {
  target_root_ids = var.include_root ? [local.root_id] : []  
}

#This code is merging all OUs, accounts and the root into one target for the SCP application
locals {
  all_target_ids = concat(#concat combines different lists into one list.
    local.target_ou_ids,
    local.target_account_ids,
    local.target_root_ids
  )
}

#This is information about SCP
resource "aws_organizations_policy" "scp_policy" {
  name        = var.scp_name
  description = var.scp_description
  content     = var.scp_json_path
  type        = var.scp_type
}

#This code is attaching SPC to merged targets
resource "aws_organizations_policy_attachment" "attachments" {
  for_each = toset(local.all_target_ids) #toset is going to remove duplicated also convert OUs and account into same general type

  policy_id = aws_organizations_policy.scp_policy.id
  target_id = each.value
}


##