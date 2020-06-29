# assume_role.sh

Helper script for assuming a role within AWS. Intended for command-line use, or wrapping round scripting using Terraform.

## Usage

`assume_role.sh <roleName>`

If you specify a valid role and have permission to assume it, the environment vars are set to operate using that assumed role.

If you specify a non-existent role or role you have no permission to assume, the vars are unset, returning you to your standard config.

## Pre-requisites

-   You need the AWS CLI installed and already configured with a profile with access to your account.
-   You need `jq` installed within the environment to allow command-line Javascript parsing.

## Scenarios:

-   Use this script as a base, adding commands covering what you need to do with the assumed role e.g. Terraform execution.
-   Source environment from this into an existing shell with
    ```
    . ./assume_role.sh
    ```
    This will export the right values to allow interactive AWS CLI in current shell under the assumed role.
