variable "s3_bucket_name" {
  description = "Name to apply to the S3 bucket resource"
}
variable "cf_oai_iam_arn" {
  description = "The ID of the cloudfront distribution's original access identity"
}
variable "cf_id" {
  description = "ID of the cloudfront distribution"
}