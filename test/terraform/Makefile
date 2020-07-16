SHELL := /bin/bash

apply: 
	@terraform init
	@terraform fmt
	@terraform plan
	@terraform apply -auto-approve

destroy:
	@terraform destroy -force