# Install
The infrastructure is managed with [Terraform](https://www.terraform.io/).
- Clone the project.
- Edit the `terraform.tfvars.dist` file with your credentials and rename it to `terraform.tfvars`.
- Create an SSH key and save the `id_rsa` and `id_rsa.pub` files in the project root directory.
- Run `terraform apply` command.

# Uninstall
Run `terraform destroy` command.
