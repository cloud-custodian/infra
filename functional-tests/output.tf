
output "ftest_role_arn" {
  value       = aws_iam_role.ftest_ci.arn
  description = "Role Arn For Functional Test"
}
