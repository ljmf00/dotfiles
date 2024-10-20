terraform {
  backend "remote" {
    organization = "devtty63"

    workspaces {
      name = "dotfiles"
    }
  }

  required_version = ">= 0.13.0"
}
