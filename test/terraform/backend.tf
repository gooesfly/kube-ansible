terraform {
  backend "s3" {
    bucket                      = "terraform"
    endpoint                    = "http://172.16.1.10:9000"
    access_key                  = "minioadmin"
    secret_key                  = "minioadmin"
    key                         = "kube-ansible.tfstate"
    region                      = "us-east-1"
    force_path_style            = true
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}

# terraform {
#   backend "s3" {
#     bucket                      = "${bucket}"
#     endpoint                    = "${var.endpoint}"
#     access_key                  = "${var.access_key}"
#     secret_key                  = "${var.secret_key}"
#     key                         = "kube-ansible.tfstate"
#     region                      = "us-east-1"
#     force_path_style            = true
#     skip_requesting_account_id  = true
#     skip_credentials_validation = true
#     skip_get_ec2_platforms      = true
#     skip_metadata_api_check     = true
#     skip_region_validation      = true
#   }
# }

