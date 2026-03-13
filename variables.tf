variable "scp_name" {
  type = string
}

variable "scp_description" {
  type = string
}

variable "scp_path" {
  type = string
}

variable "scp_type" {
  type = string
}

variable "target_ou_names" {
  type = list(string)
  description = "scp target ou name, leave it blank, it you don't want to attach scp to ou"
}

variable "target_account_names" {
  type = list(string)
  description = "scp target account names, leave it blank, it you don't want to attach scp to account"
}

variable "include_root" {
  type = bool
  description = "include root_id = true, exlclude root_id = false"
}