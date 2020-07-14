SHELL := /bin/bash

apply: 
	@terraform init
	@terraform fmt
	@terraform plan

destroy:
	@terraform destroy -force