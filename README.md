# checkly-terraform-getting-started

A sample repository showing a minimal Terraform Checkly setup.

## Setup

First, you will need an API Key for your Checkly user. Go to the [API keys tab](https://app.checklyhq.com/settings/user/api-keys) in your user settings and click `Create API key`. 

Get your User API key and add it to your env using your terminal:

```bash
$ export TF_VAR_checkly_api_key=cu_xxx
```

You also need to set your target account ID, which you can find under your [account settings](https://app.checklyhq.com/settings/account/general). 

If you don't have access to account settings, please contact your account owner/admin.

```bash
$ export TF_VAR_checkly_account_id=xxx
```

Running `terraform init` will install the Checkly Terraform provider for you, as well as initialising your project. 

## Usage

Running `terraform apply` will have Terraform draft a plan and ask you to confirm by typing `yes`. Once that is done, Terraform will go ahead and create the resources for you.

## Links

See Checkly's Terraform [Getting Started](https://checklyhq.com/docs/terraform-provider/getting-started/) docs for more information.