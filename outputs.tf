output "boot_disk_id" {
  description = "The ID of the boot disk created for the instance."
  value       = yandex_compute_disk.boot_disk.id
}

output "instance_id" {
  description = "The ID of the Yandex Compute instance."
  value       = yandex_compute_instance.this.id
}

output "subnet_id" {
  description = "The ID of the VPC subnet used by the Yandex Compute instance."
  value       = yandex_vpc_subnet.private.id
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

output "instance_public_ip_address" {
  description = "The external IP address of the instance."
  value       = yandex_compute_instance.this.network_interface.0.nat_ip_address
} 

# доп. задание 2 в теме Functions
# Добавьте ещё одну подсеть с CIDR-блоком в переменную subnets и добавьте локальное значение со списком, 
# содержащим все CIDR-блоки, с помощью функции flatten. 
output "all_subnets" {
  value = flatten(values(var.subnets))
}
