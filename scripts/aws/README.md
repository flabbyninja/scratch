# assume_role.sh

Utility script to help with assuming a role within AWS. If you specify a valid role and you can assume it, the environment vars are set for using the assumed role. If you specify a non-existent role or role you have no permission to, the vars are unset, returning you to your standard profile config.

## Pre-requisites

* You need the AWS CLI installed and already configured with a profile to access your account.
* You need `jq` installed within the environment

## Usage:

* Extend this so it runs the commands you need to run as this user e.g. Terraform
* Source into existing shell with `. ./assume_role.sh` to export into current shell and allow use of arbitrary commands