resource "aws_securityhub_account" "member" {
  provider = "aws.member"
}

# resource "aws_securityhub_standards_subscription" "member" {
#   provider = "aws.member"
#   depends_on = ["aws_securityhub_account.member"]
#   standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
# }
#
# resource "aws_securityhub_product_subscription" "securityhub-guardduty" {
#   provider = "aws.member"
#   depends_on = ["aws_securityhub_account.member"]
#   product_arn = "arn:aws:securityhub:${data.aws_region.member.name}::product/aws/guardduty"
# }
#
# resource "aws_securityhub_product_subscription" "securityhub-inspector" {
#   provider = "aws.member"
#   depends_on = ["aws_securityhub_account.member"]
#   product_arn = "arn:aws:securityhub:${data.aws_region.member.name}::product/aws/inspector"
# }
#
# resource "aws_securityhub_product_subscription" "securityhub-macie" {
#   provider = "aws.member"
#   depends_on = ["aws_securityhub_account.member"]
#   product_arn = "arn:aws:securityhub:${data.aws_region.member.name}::product/aws/macie"
# }