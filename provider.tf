terraform {
	required_providers{
	aws = {
	source = "hashicorp/aws"
		}
	}
}

provider "aws" {
	region = "us-west-2"
	shared_credential_file = "~/.aws/creds"
	provide = "vscode"
}


