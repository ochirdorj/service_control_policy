# service_control_policy

A Terraform module for creating and attaching AWS Service Control Policies (SCPs) to targets within an AWS Organization. Targets can be Organizational Units (OUs), individual accounts, or the organization root.

## Features

- Creates an SCP from a local policy JSON file
- Attaches the SCP to one or more OUs (by name)
- Attaches the SCP to one or more accounts (by name)
- Optionally attaches the SCP to the organization root

## Usage

```hcl
module "scp" {
  source = "path/to/service_control_policy"

  scp_name        = "deny-s3-public-access"
  scp_description = "Denies S3 bucket public access across all accounts"
  scp_path        = "${path.module}/policies/deny_s3_public.json"
  scp_type        = "SERVICE_CONTROL_POLICY"

  include_root         = false
  target_ou_names      = ["Production", "Staging"]
  target_account_names = []
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

The AWS provider must be configured with credentials that have `organizations:*` permissions.

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `scp_name` | `string` | yes | Name of the SCP policy |
| `scp_description` | `string` | yes | Description of the SCP policy |
| `scp_path` | `string` | yes | Path to the SCP policy JSON file |
| `scp_type` | `string` | yes | Policy type — typically `SERVICE_CONTROL_POLICY` |
| `include_root` | `bool` | yes | Set to `true` to attach the SCP to the organization root |
| `target_ou_names` | `list(string)` | yes | Names of OUs to attach the SCP to. Pass an empty list to skip |
| `target_account_names` | `list(string)` | yes | Names of accounts to attach the SCP to. Pass an empty list to skip |

## Outputs

This module does not define outputs. The created policy and attachments can be referenced via `aws_organizations_policy.scp_policy` and `aws_organizations_policy_attachment.attachments` within the module.

## How it works

1. Reads the current AWS Organization and its root OU.
2. Retrieves all child OUs under the root and filters them by `target_ou_names`.
3. Retrieves all accounts in the organization and filters them by `target_account_names`.
4. Optionally includes the root ID if `include_root = true`.
5. Creates the SCP using the content of the file at `scp_path`.
6. Attaches the SCP to every resolved target ID.

## License

MIT
