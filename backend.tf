terraform {
  backend "s3" {
    bucket = "cicdbackend3"  # Replace with your S3 bucket name
    key    = "s3://cicdbackend3/cicd_terraform/" # Path within the bucket
    region = "us-east-1" # Your AWS region
    # For state locking (recommended)
    # encrypt = true # For encrypting state at rest (recommended)
  }
}
