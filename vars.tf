variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}


variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-08f3d892de259504d"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "source_prefix"{
  type = string
  description = "crates unique name beginning with specified prefix"
  default =  "okocha-source-buck-"
}

variable "destination_prefix"{
  type = string
  description = "destination bucket"
  default =  "okocha-dest-buck-"
}

variable "tags" {
  type = map
  description = "(Optional) A mapping of tags to assign to bucket."
  default = {
        environment = "DEV"
        terraform = "true"
  }
}

variable "versioning_is_enabled" {
  type = bool
  description = "Flag to indicate if versioning is on or off"
  default = true
}

variable "is_kms" {
  type = bool
  description = "Flag to set encryption"
  default = true
}

