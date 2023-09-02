# used this for tags.
variable "tag_name" {
  type    = string
  default = "eks-cluster-1"

}

variable "tag_env" {
  type    = string
  default = "project"

}

variable "aws_access_key" {
  type    = string
  default = "Z5UNKFHP3BGTXU" #Not used

}
variable "aws_access_secret" {
  type    = string
  default = "5I43+QZ1FrQ44gKcym7aDt86biejQUZ" #not used
}
variable "aws_region" {
  type    = string
  default = "us-east-1"

}
variable "aws_type" {
  type    = string
  default = "json"

}