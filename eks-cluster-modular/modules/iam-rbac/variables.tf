variable "allowed_admin_principals" {
  description = "ARNs (user/role/SSO) autorisés à assumer eks-admin"
  type        = list(string)
}
variable "allowed_dev_principals" {
  description = "ARNs autorisés à assumer eks-devs"
  type        = list(string)
}
