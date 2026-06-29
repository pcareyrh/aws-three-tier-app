  enforcement_level = "advisory"
}

policy "ec2-ebs-encryption-enabled" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/ec2/ec2-ebs-encryption-enabled.sentinel"
  enforcement_level = "advisory"
}

policy "ec2-metadata-imdsv2-required" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/ec2/ec2-metadata-imdsv2-required.sentinel"
  enforcement_level = "advisory"
}

policy "ec2-network-acl" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/ec2/ec2-network-acl.sentinel"
  enforcement_level = "advisory"
}

policy "ec2-security-group-ingress-traffic-restriction-port" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/ec2/ec2-security-group-ingress-traffic-restriction-port.sentinel"
  enforcement_level = "advisory"
}

policy "ec2-security-group-ingress-traffic-restriction-protocol" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/ec2/ec2-security-group-ingress-traffic-restriction-protocol.sentinel"
  enforcement_level = "advisory"
}

policy "ec2-vpc-default-security-group-no-traffic" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/ec2/ec2-vpc-default-security-group-no-traffic.sentinel"
  enforcement_level = "advisory"
}

policy "ec2-vpc-flow-logging-enabled" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/ec2/ec2-vpc-flow-logging-enabled.sentinel"
  enforcement_level = "advisory"
}

policy "cloudtrail-bucket-access-logging-enabled" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/cloudtrail/cloudtrail-bucket-access-logging-enabled.sentinel"
  enforcement_level = "advisory"
}

policy "cloudtrail-cloudwatch-logs-group-arn-present" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/cloudtrail/cloudtrail-cloudwatch-logs-group-arn-present.sentinel"
  enforcement_level = "advisory"
}

policy "cloudtrail-log-file-validation-enabled" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/cloudtrail/cloudtrail-log-file-validation-enabled.sentinel"
  enforcement_level = "advisory"
}

policy "cloudtrail-logs-bucket-not-public" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/cloudtrail/cloudtrail-logs-bucket-not-public.sentinel"
  enforcement_level = "advisory"
}

policy "cloudtrail-server-side-encryption-enabled" {
  source            = "https://raw.githubusercontent.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform/release/1.0.2/policies/cloudtrail/cloudtrail-server-side-encryption-enabled.sentinel"
  enforcement_level = "advisory"
}