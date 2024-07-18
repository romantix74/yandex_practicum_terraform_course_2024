# To activate grouping mode, add the symbol ... after the value expression
output "boot_disk_id" {
  description = "The ID of the boot disk created for the instance."
  # value       = yandex_compute_disk.boot_disk_old.id
  value = {
    for disk in yandex_compute_disk.boot_disk :
    disk.name => disk.id...
  }
}

output "instance_ids" {
  description = "The ID of the Yandex Compute instance."
  value = {
    for instance in yandex_compute_instance.this :
    instance.name => instance.id...
  }
}

output "subnet_ids" {
  description = "The ID of the VPC subnet used by the Yandex Compute instance."
  value = {
    for subnet in yandex_vpc_subnet.private :
    subnet.name => subnet.id...
  }
}

output "ydb_id" {
  description = "The ID of the Yandex Managed Service for YDB instance."
  value       = yandex_ydb_database_serverless.this.id
}

output "service_account_id" {
  description = "The ID of the Yandex IAM service account."
  value       = yandex_iam_service_account.bucket.id
}

output "bucket_name" {
  description = "The name of the Yandex Object Storage bucket."
  value       = yandex_storage_bucket.this.bucket
}


output "yandex_iam_service_account_static_access_key" {
  description = "The static access key of yandex_iam_service_account."
  value       = yandex_iam_service_account_static_access_key.this.secret_key
  sensitive   = true
}

# output "instance_public_ip_address" {
#   description = "The external IP address of the instance."
#   value = {
#     for address in yandex_vpc_address.this :
#     address.name => address.external_ipv4_address[0].address...
#   }
# } 
