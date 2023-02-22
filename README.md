# $${\color{blue}GCP-Project}$$	
## A brief about the infrastructure of the project:
**Infrastructure of the project will be deployed using `Terraform files` and will create resources as following:**
***`VPC` with name `vpc-main` that contains: `management-Subnet` and `restricted-subnet`***
***`management-subnet` contains: `VM-Instance` private which allowed to be accessed only from IAP with name `instance-management` and `Cloud NAT` with name `management-nat`
***`restricted-subnet` contains: a private `GKE-Cluster` that will have the deployment of `Jenkins` "main pod master-node" and `Jenkins-slave-pod` "worker pod worker-node in Jenkins"
***By using `Jenkins` and his nodes it will trigger the GitHub repo. of the development team and with pipeline it will automate the process of `Building Image` and `Pushing it` to DockerHub Repository & Automatically create `deployment` & service `load-balancer-svc` in the `GKE-Cluster`.   
**The next photo shows the required infrastructure that will be deployed and what is the project lifecycle:**
<img src="images/Project-brief.jpg" width=400 >
###                ______________________________________________________________________________________________


> ## Follow the next steps to run this project:

## Pre-Requests:

**Follow the steps inside each link from the following to finish the pre-requests:**

> 1- GCP-Project 
```
https://cloud.google.com/resource-manager/docs/creating-managing-projects 
```
> 2- gcloud sdk on your local machine 
```
https://cloud.google.com/sdk/docs/install
```
> 3- Install Docker in your local machine
```
https://docs.docker.com/engine/install
```
> 5- Configure Docker on your local machine with cloud SDK 
```
https://cloud.google.com/container-registry/docs/advanced-authentication
```
> 6- Terraform setup on you local machine
```
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli 
```
> 7- install git on your local machine
```
https://github.com/git-guides/install-git
```
> 8- install Ansible in your local machoine
```

```
### --------------------------------------------------
### 1- Creating the infrastructure of the project on GCP:

> 1- In a new directory use the next command in the bash shell to download the files from this repo
```
git clone git@github.com:HusseinGhoarba/GCP-Project.git
```
> 2- Open file `terraform-files` and edit on files `terraform.tfvars` values of : 
	
	2-1- `user-project-id` --> add  `<your-project-id>`
	
	2-2- `user-region`     --> add  `<your-prefered-region>`
	
	2-3- `user-zone`       --> add  `<your-prefered-zone>`
	
     Open file `user-data.sh` and edit the value of the zone inside the line `no.25` with your `<your-prefered-zone>`

> 3- run the following commands as follows:
```
terraform init
```
screenshot from the command:

<img src="images/terraform/01-init.png" width=400 >

```
terraform plan
```
screenshot from the command:

<img src="images/terraform/02-terraform plan.png" width=400 >

```
terraform apply
```
screenshot from the command:

<img src="images/terraform/03-apply.png" width=400 >

```
yes
```
<img src="images/terraform/04-yes-for-applying.png" width=400 >


### --------------------------------------------------
### 2- Building Docker-Image and Push it:

> 1- change your directory to the app-python and run the following command in your terminal after changing `<your-project-id>` with yours:
```
docker build . -t gcr.io/<your-project-id>/my-python-app
```
screenshot from the command:

<img src="images/docker/01-docker-build.png" width=400 >

> 2- Push the created image by the following command to your container registry of your google cloud project after changing `<your-project-id>` with yours:
```
docker push gcr.io/<your-project-id>/my-python-app:latest
```
screenshot from the command:

<img src="images/docker/02-docker-push.png" width=400 >

### --------------------------------------------------
### 3- Deploy the image into the cluster using the private vm:
**"General Hint: make sure to replace the `<your-project-id>` with yours and replace the `<your-preferred-zone>` with yours"**
> 1- Connect to the private-instance which is in the management-subent: 
```
gcloud compute ssh --project=<your-project-id>  --zone=<your-added-preferred-zone> instance-management
```
screenshot from the command:

<img src="images/deployment/01-ssh-to-private-vm.png" width=400 >

> 2- Download the files of the repo. using git:
```
git clone https://github.com/HusseinGhoarba/GCP-Project.git
```
screenshot from the command:

<img src="images/deployment/02-git-clone-of-the-files.png" width=400 >

> 3- connect to the cluster:
```
gcloud container clusters get-credentials python-cluster --zone <your-added-preferred-zone> --project <your-project-id>
```
screenshot from the command:

<img src="images/deployment/03-configure-the-cluster.png" width=400 >

> 4- change your current directory to GCP-Project:
```
cd GCP-Project/
```
> 5- deploy the resources into the python-cluster:
```
kubectl apply -f deployment/
```
screenshot from the command:

<img src="images/deployment/04-create-deployment.png" width=400 >

> 6- make sure that all pods are running and get services:
```
kubectl get po
```
screenshot from the command:

<img src="images/deployment/05-get-pods.png" width=400 >

```
kubectl get svc
```
screenshot from the command:

<img src="images/deployment/06-get-svc.png" width=400 >

> 7- from the previous step get the external of the IP as the next photo and the port and go to any web-browser and write `<external-ip>:<port>`:
screenshot from the command:

<img src="images/deployment/07-get-the-ip-of-load-balancer.png" width=400 >

### --------------------------------------------------
### Finally: 
***I want to THANK YOU & If there is any problem don't hesitate to send to me***
### --------------------------------------------------
### Project Contributers:
|![Hussein Ghoraba](images/hussein.jpg)|
|:-----------------:|
|[Hussein Ghoraba](https://github.com/HusseinGhoarba)|
