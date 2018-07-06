resource "aws_config_configuration_recorder" "config" {
  provider = "aws.member"
  name = "config-${data.aws_caller_identity.member.account_id}"
  role_arn = "${aws_iam_role.config_role.arn}"
  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_iam_role" "config_role" {
  provider = "aws.member"
  name = "config-role"
  assume_role_policy = "${file("${path.module}/policies/config-sts.json")}"
}

resource "aws_iam_role_policy_attachment" "config_policy" {
  provider = "aws.member"
  role = "${aws_iam_role.config_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_config_configuration_recorder_status" "config" {
  provider = "aws.member"
  name = "${aws_config_configuration_recorder.config.name}"
  is_enabled = true
}

resource "aws_config_aggregate_authorization" "member" {
  provider = "aws.master"
  count = "${length(var.aws_regions)}"
  account_id = "${data.aws_caller_identity.member.account_id}"
  # region = "${data.aws_region.member.name}"
  region = "${element(var.aws_regions, count.index)}"
}

resource "aws_config_delivery_channel" "member" {
  provider = "aws.member"
  name = "aws-config-${data.aws_caller_identity.member.account_id}"
  s3_bucket_name = "aws-config-${data.aws_caller_identity.member.account_id}"
  sns_topic_arn = ""
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
}

resource "aws_iam_role_policy_attachment" "config_sns_policy" {
  provider = "aws.master"
  role = "${var.org["config_sns_role_name"]}"
  policy_arn = "${aws_iam_policy.config_sns_policy.arn}"
}

resource "aws_iam_policy" "config_sns_policy" {
  provider = "aws.master"
  name = "aws-config-${data.aws_caller_identity.member.account_id}"
  policy = "${data.template_file.config_sns_role_policy.rendered}"
}

data "template_file" "config_sns_role_policy" {
  template = "${file("${path.module}/policies/config-sns.json")}"
  vars {
    config_role_arn = "${aws_iam_role.config_role.arn}"
  }
}