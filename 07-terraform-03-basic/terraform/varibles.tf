variable "region" {
  description = "This is the cloud hosting region."
}

variable "az" {
  description = "This is the availability zones."
}

variable "tags" {
  description = "This is the master tags."
  type        = map(string)
  default     = {}
}