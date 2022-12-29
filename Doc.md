## Requirements

No requirements.

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.48.0  |

## Modules

| Name                                                                                                                                              | Source                               | Version |
|---------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront)                                                                                | terraform-aws-modules/cloudfront/aws | n/a     |
| <a name="module_s3_any_site_bucket"></a> [s3\_any\_site\_bucket](#module\_s3\_any\_site\_bucket)                                                  | terraform-aws-modules/s3-bucket/aws  | n/a     |
| <a name="module_s3_any_site_cloudfront_access_log"></a> [s3\_any\_site\_cloudfront\_access\_log](#module\_s3\_any\_site\_cloudfront\_access\_log) | terraform-aws-modules/s3-bucket/aws  | n/a     |

## Resources

| Name                                                                                                                                                                         | Type        |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_cloudfront_function.any_site_basic_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function)                               | resource    |
| [aws_cloudfront_origin_access_control.any_site_cloudfront_oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource    |
| [aws_iam_policy_document.s3_any_site_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                      | data source |

## Inputs

No inputs.

## Outputs

No outputs.
