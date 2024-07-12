# Local values
locals {
  boot_disk_name      = "${var.name_prefix}-boot-disk"
  linux_vm_name       = "${var.name_prefix}-linux-vm"
  vpc_network_name    = "${var.name_prefix}-private"
  ydb_serverless_name = "${var.name_prefix}-ydb-serverless"
  bucket_sa_name      = "${var.name_prefix}-bucket-sa"
  bucket_name         = "${var.name_prefix}-terraform-bucket-${random_string.bucket_name.result}"
}

# Создание диска и виртуальной машины
resource "yandex_compute_disk" "boot_disk" {
  name     = local.boot_disk_name
  zone     = var.zone
  image_id = var.image_id
  
  type = var.instance_resources.disk.disk_type
  size = var.instance_resources.disk.disk_size
}

resource "yandex_compute_instance" "this" {
  name                      = local.linux_vm_name
  allow_stopping_for_update = true
  platform_id               = var.instance_resources.platform_id
  zone                      = var.zone

  resources {
    cores  = var.instance_resources.cores
    memory = var.instance_resources.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk.id
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.private.id
    nat            = true
    nat_ip_address = yandex_vpc_address.this.external_ipv4_address[0].address
  }

  metadata = {
    user-data = templatefile("cloud-init.yaml.tftpl", {
      ydb_connect_string = yandex_ydb_database_serverless.this.ydb_full_endpoint,
      bucket_domain_name = yandex_storage_bucket.this.bucket_domain_name
    })
    ssh_keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

# Создание VPC и подсети
resource "yandex_vpc_network" "this" {
  name = local.vpc_network_name
}

resource "yandex_vpc_subnet" "private" {
  name           = keys(var.subnets)[0]
  zone           = var.zone
  v4_cidr_blocks = var.subnets[keys(var.subnets)[0]]
  network_id     = yandex_vpc_network.this.id
}

resource "yandex_vpc_address" "this" {
  name = "${local.linux_vm_name}-adress"
  external_ipv4_address {
    zone_id = var.zone
  }
}

# Создание Yandex Managed Service for YDB
resource "yandex_ydb_database_serverless" "this" {
  name = local.ydb_serverless_name
}

# Создание сервисного аккаунта 
resource "yandex_iam_service_account" "bucket" {
  name = local.bucket_sa_name
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "storage_editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "this" {
  service_account_id = yandex_iam_service_account.bucket.id
  description        = "static access key for object storage"
}

# Создание бакета 
resource "yandex_storage_bucket" "this" {
  bucket     = local.bucket_name
  access_key = yandex_iam_service_account_static_access_key.this.access_key
  secret_key = yandex_iam_service_account_static_access_key.this.secret_key
  
  depends_on = [ yandex_resourcemanager_folder_iam_member.storage_editor ]
}

resource "random_string" "bucket_name" {
  length  = 8
  special = false
  upper   = false
}
