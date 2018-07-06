data "aws_vpcs" "vpcs" {
  provider = "aws.member"
}

resource "aws_cloudwatch_log_group" "vpc_log" {
  provider = "aws.member"
  count = "${length(data.aws_vpcs.vpcs.ids)}"
  name = "${element(data.aws_vpcs.vpcs.ids, count.index)}"
}

resource "aws_flow_log" "vpc_log" {
  provider = "aws.member"
  count = "${length(data.aws_vpcs.vpcs.ids)}"
  log_group_name = "${element(aws_cloudwatch_log_group.vpc_log.*.name, count.index)}"
  iam_role_arn = "${aws_iam_role.vpc_log.arn}"
  vpc_id = "${element(data.aws_vpcs.vpcs.ids, count.index)}"
  traffic_type = "ALL"
}

resource "aws_iam_role" "vpc_log" {
  provider = "aws.member"
  name = "vpc_log"
  assume_role_policy = "${file("${path.module}/policies/vpc-flowlog-sts.json")}"
}

resource "aws_iam_role_policy" "vpc_log_policy" {
  provider = "aws.member"
  name = "vpc_log_policy"
  role = "${aws_iam_role.vpc_log.id}"
  policy = "${file("${path.module}/policies/vpc-flowlog-role.json")}"
}