variable "github_repos" {
  type        = list(string)
  description = "list of *full* repo names in the org that should be allowed access to the role"
}


variable "resource_tags" {
  type        = map(any)
  description = "Tags to be applied to all resources."
}


