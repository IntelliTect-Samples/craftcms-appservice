# craftcms-appservice

This repository demonstrates building and deploying Craft CMS to Azure App Service.

The repository contains two distinct sections of code in directories: Terraform and Docker. 

### Terraform

The Terraform directory container the Infrastructure as Code (IaC) Terraform files to build the Azure resource infrastructure for the CraftCMS Docker image to run in. This code uses the [Azurerm Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) to create Azure resources. 

### Docker

The Docker portion of the repository is for creating a Docker image containing an installation of CraftCMS which will run in the Azure Web App Service in Azure deployed by the Terraform section of the repository.


[Craft](https://craftcms.com/) is a flexible, user-friendly CMS for creating custom digital experiences on the web and beyond.

In technical terms, it’s a self-hosted PHP application backed by a MySQL or Postgres database. Read more in the [official documentation](https://craftcms.com/docs).

The CraftCMS source code can be found here [`craftcms/cms`](https://github.com/craftcms/cms). This repository uses a sample project for its installation which can be found here for further updates [`craftcms/craft`](https://github.com/craftcms/craft/blob/5.x).  

# Getting Started

## Provision Azure resources

## Build Docker image and push to Azure container registry

This repo includes a version of craft from [tbd]()


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

## Create Azure Resources

Use this process to provision the required Azure resources including App Service, MySQL, Container Registry and Storage

Terraform state is stored in an Azure Storage account for backend state storage. This account will need to be manually created and details configured in backend configuration


- For [`Terraform`]([link-url](https://www.terraform.io/)) the sakteaterraformstate storage account will need to have the IP address added to the firewall when running Terraform commands. 

### Run Terraform Init, Plan and Apply  

The same terrafrom script is used to provision dev, stage and prod environments. The environment is determined by passing in the appropriate set of values via a terraform variables configurat or ".tfvars" file

Note that each environment is considered different so a different "backend" state file is maintained for each environment and is determed by the ```-backend-config``` parameter

Each environment has distinct values for service name and potentially other settings. These are determined by the tfvars file.

#### Terraform INIT

```
terraform init -reconfigure -backend-config='.backend/dev.azurerm.tfbackend' -var-file='.backend/dev.tfvars'<br />
```

#### Terraform PLAN
Generate a resource plan using the ```plan``` command
```
terraform plan -out 'plan.tfplan' -var-file='.backend/dev.tfvars'<br />
```

#### Terraform APPLY
Apply a generated plan using the ```apply``` command

```
terraform apply 'plan.tfplan'
```

#### Terraform DESTROY
To remove all resources that were created by the apply, use the ```-destroy``` option on the plan

```
terraform plan -out 'plan.tfplan' -var-file='.backend/stage.tfvars' -destroy
terraform apply 'plan.tfplan'
```

## Notes

- Logging is currently manually configured for each environment with diagnostic settings etc. 
- A CraftCMS database needs to be initialized:
	* Do a MySQL Workbench or command line dump export of the craftcms database
	* Do an import using the dump file on the new environment craftcms database
		- If the database was named different than the database used for the export you will need to edit the dump file and change the exported database name references to the import database name 
- Copy the container image tag from one environment to another or build and deploy a new one the the new environment
- Update Docker credentials for the web app environment variables for the new environment 
- Update settings in CraftCMS that contain references to the copied environment such as file system paths for assets 
- Create assets folder on the storage account files container 


