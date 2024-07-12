


```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

terraform plan  
terraform apply  


#### Доп задание по выводу sensitive output
```
terraform output yandex_iam_service_account_static_access_key
```