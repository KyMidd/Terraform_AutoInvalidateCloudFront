resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name = var.s3_bucket_name
  }
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.aws_s3_bucket.bucket_regional_domain_name
}

resource "aws_s3_bucket_policy" "PolicyForCloudFrontPrivateContent" {
  bucket = aws_s3_bucket.aws_s3_bucket.id
  policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Id" : "PolicyForCloudFrontPrivateContent",
      "Statement" : [
        {
          "Sid" : "1",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : var.cf_oai_iam_arn
          },
          "Action" : "s3:GetObject",
          "Resource" : "${aws_s3_bucket.aws_s3_bucket.arn}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_acl" "aws_s3_bucket-example" {
  bucket = aws_s3_bucket.aws_s3_bucket.id
  acl    = "private"
}

# Upload sample web site for testing to bucket
resource "aws_s3_object" "website" {
  bucket       = aws_s3_bucket.aws_s3_bucket.id
  key          = "index.html"
  acl          = "private"
  source       = "./website/index.html"
  etag         = filemd5("./website/index.html")
  content_type = "text/html"
}

# Invalidate the CF cache when S3 website home page is updated
resource "null_resource" "invalidate_cf_cache" {
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${var.cf_id} --paths '/*'"
  }
  triggers = {
    website_version_changed = aws_s3_object.website.version_id
  }
}

resource "aws_s3_bucket_website_configuration" "web_hosting" {
  bucket = aws_s3_bucket.aws_s3_bucket.id

  index_document {
    suffix = "index.html"
  }
}
