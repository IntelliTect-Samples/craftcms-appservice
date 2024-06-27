# craftcms-appservice

This repository contains two distict sections of code in directories Terraform and Docker. 
<br />
### Terraform
<br />

The Terraform directory container the Infrastructure as Code (IaC) Terraform files to build the Azure resource infrastructure for the CraftCMS Docker image to run in. This code uses the [Azurerm Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) to create Azure resources. 

### Docker

The Docker portion of the repository is for creating a Docker image containing an installation of CraftCMS which will run in the Azure Web App Service in Azure deployed by the Terraform section of the repository.


[Craft](https://craftcms.com/) is a flexible, user-friendly CMS for creating custom digital experiences on the web and beyond.

In technical terms, it’s a self-hosted PHP application backed by a MySQL or Postgres database. Read more in the [official documentation](https://craftcms.com/docs).

The CraftCMS source code can be found here [`craftcms/cms`](https://github.com/craftcms/cms). This repository uses a sample project for its installation which can be found here for further updates [`craftcms/craft`](https://github.com/craftcms/craft/blob/5.x).  

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references


## Build Docker image and push to Azure container registry

1. Build the docker image with Docker file

    ```docker
    docker build . --no-cache --build-arg php_version=8.3 --build-arg ubuntu_version=24.14 --progress plain --tag craftcms:latest
    ```

2. Tag the Docker image to be pushed to the Azure container registry
   
    ```docker
    docker tag craftcms:latest [CONTAINER-REGISTRY-NAME].azurecr.io/craftcms:latest
    ```

3. Get an access token required to authrnticate to container registry 
   
    ```docker
    TOKEN=$(az acr login --name [CONTAINER-REGISTRY-NAME]  --expose-token --output tsv --query accessToken)
    
    docker login [CONTAINER-REGISTRY-NAME].azurecr.io --username 00000000-0000-0000-0000-000000000000 --password-stdin <<< $TOKEN
    ```

4. Push new tagged image to the Azure container registry 
   
    ```docker
    docker push [CONTAINER-REGISTRY-NAME].azurecr.io/craftcms:latest
    ```

Process to create new Azure container app Environment
---
<br />

- For [`Terraform`]([link-url](https://www.terraform.io/)) the sakteaterraformstate storage account will need to have the IP address added to the firewall when running Terraform commands. 

### Run Terraform Init, Plan and Apply  

#### Terraform INIT
```
terraform init -reconfigure -backend-config='.backend/dev.azurerm.tfbackend' -var-file='.backend/dev.tfvars'<br />
terraform init -reconfigure -backend-config='.backend/stage.azurerm.tfbackend' -var-file='.backend/stage.tfvars'<br />
terraform init -reconfigure -backend-config='.backend/prod.azurerm.tfbackend' -var-file='.backend/prod.tfvars'<br />
```

#### Terraform PLAN
```
terraform plan -out 'plan.tfplan' -var-file='.backend/dev.tfvars'<br />
terraform plan -out 'plan.tfplan' -var-file='.backend/stage.tfvars'<br />
terraform plan -out 'plan.tfplan' -var-file='.backend/prod.tfvars'<br />
```

#### Terraform APPLY
```
terraform apply 'plan.tfplan'
```

#### Terraform DESTROY
```
terraform plan -out 'plan.tfplan' -var-file='.backend/stage.tfvars' -destroy
terraform apply 'plan.tfplan'
```

<br />

- Need to manually configure logging for each environment with diagnostic settings etc. 

- Need to configure the CraftCMS database 
	* Do a MySQL Workbench or command line dump export of the craftcms database
	* Do an import using the dump file on the new environment craftcms database
		- If the database was named different than the database used for the export you will need to edit the dump file and change the exported database name references to the import database name 
	

- Copy the container image tag from one environment to another or build and deploy a new one the the new environment

- Update Docker credentials for the web app environment variables for the new environment 

- Update settings in CraftCMS that contain references to the copied environment such as file system paths for assets 

- Create assets folder on the storage account files container 


