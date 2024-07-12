
Файл в домшней директории  
```
.terraformrc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

terraform plan  
terraform apply  

#### terraform.tfvars example
```
folder_id = "b1gfe1trpem7cgvho5uk"
name_prefix = "project-dev"
subnets = {
  "project-dev-subnet" = ["192.168.11.0/24"]
}
instance_resources = {
  cores  = 2
  memory = 2
}
```


#### Доп задание по выводу sensitive output
```
terraform output yandex_iam_service_account_static_access_key
```


#### logs
yandex_storage_bucket.this: Refreshing state... [id=project-dev-terraform-bucket-ui8mqpc7]
