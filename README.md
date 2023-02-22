# $${\color{blue}GCP-Infrastructure-of-Final-ITI-Project}$$	
## A brief about the infrastructure of the project:
**Infrastructure of the project will be deployed using `Terraform files` and will create resources as following:**

***1-`VPC` with name `vpc-main` that contains: `management-Subnet` and `restricted-subnet`***

***2-`management-subnet` contains: `VM-Instance` private which allowed to be accessed only from IAP with name `instance-management` and `Cloud NAT` with name `management-nat`***

***3-`restricted-subnet` contains: a private `GKE-Cluster` that will have the deployment of `Jenkins` "main pod master-node" and `Jenkins-slave-pod` "worker pod worker-node in Jenkins"`***

**By using `Jenkins` and his nodes it will trigger the GitHub repo. of the development team and with pipeline it will automate the process of `Building Image` and `Pushing it` to DockerHub Repository & Automatically create `deployment` & service `load-balancer-svc` in the `GKE-Cluster`**   

**The next photo shows the required infrastructure that will be deployed and what is the project lifecycle:**

<img src="images/Project-brief.jpg" width=600 >


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

<img src="images/terraform/01-Terraform-init.png" width=400 >

```
terraform plan
```
screenshot from the command:

<img src="images/terraform/02-Terraform-plan.png" width=400 >

```
terraform apply
```
screenshot from the command:

<img src="images/terraform/03-Terraform-apply.png" width=400 >

```
yes
```
<img src="images/terraform/04-yes.png" width=400 >


### --------------------------------------------------
### 2- Building Docker-Image and Push it:

> 1- change your directory to the directory `jenkins-slave` which is inside the downloaded directory and run the following command in your terminal after changing `<your-project-id>` with yours:
```
docker build . -t gcr.io/<your-project-id>/jenkins-slave
```
screenshot from the command:

<img src="images/jk-slave/docker-img/03-build-slave-pod.png" width=400 >

> 2- Push the created image by the following command to your container registry of your google cloud project after changing `<your-project-id>` with yours:
```
docker push gcr.io/<your-project-id>/my-python-app:latest
```
screenshot from the command:

<img src="images/jk-slave/docker-img/04-push-the-image.png" width=400 >

### --------------------------------------------------
### 3- Deploy the Jenkins into the cluster using the private vm:
**"General Hint: make sure to replace the `<your-project-id>` with yours and replace the `<your-preferred-zone>` with yours"**
> 1- Connect to the private-instance which is in the management-subent: 
```
gcloud compute ssh --project=<your-project-id>  --zone=<your-added-preferred-zone> instance-management
```
screenshot from the command:

<img src="images/deploy-jenkins/01-connect-to-vm.png" width=400 >

> 2- Download the files of the repo. using git:
```
git clone https://github.com/HusseinGhoarba/FP-Infrastructure-GCP.git
```
screenshot from the command:

<img src="images/deploy-jenkins/02-git-clone.png" width=400 >

> 3- checking the version of helm which is installed in the script of the vm `metadata-script.sh` file
```
helm version
```
screenshot from the command:

<img src="images/deploy-jenkins/03-helm-version.png" width=400 >

> 4- connect to the cluster:
```
gcloud container clusters get-credentials python-cluster --zone <your-added-preferred-zone> --project <your-project-id>
```
screenshot from the command:

<img src="images/deploy-jenkins/04-connect-to-the-cluster.png" width=400 >

> 5- add helm repo to the helm repo-list
```
helm repo add jenkins https://charts.jenkins.io
```
screenshot from the command:

<img src="images/deploy-jenkins/05-add-repo-to-helm.png" width=400 >


> 6- create namespace with name <jenkins> to add the jenkins deployment and services into it
```
kubectl create ns jenkins
```
screenshot from the command:

<img src="images/deploy-jenkins/06-create-ns.png" width=400 >

> 7- Let's install deployment jenkins using helm in the python-cluster in name-space jenkins
```
helm pull jenkins/jenkins 
```
screenshot from the command:

<img src="images/deploy-jenkins/07-pull-files-from-helm.png" width=400 >

> 8- Edit the service from cluster-ip to load-balancer LoadBalancer
```
vi jenkins/values.yaml
```
**go to line 129 and at the end of word `ClusterIP`**
screenshot to show this:

<img src="images/deploy-jenkins/08-show-line-service-type.png" width=400 >

**Enter the Insert Mode with pressing `i` and change the `<ClusterIP>` to `<LoadBalancer>` then press `Esc` button then `:wq` from your keyboard:
screenshot to show this:

<img src="images/deploy-jenkins/09-changing-to-loadbalancer.png" width=400 >

> 9- Let's install deployment jenkins using helm in the python-cluster in name-space jenkins
```
helm install jenkins ./jenkins -n jenkins
```
screenshot from the command:

<img src="images/deploy-jenkins/10-install-jenkins.png" width=400 >
 
> 10- make sure that the service changed through the next command:
```
kubectl get svc -n jenkins
``` 
screenshot from the command:

<img src="images/deploy-jenkins/11-check-svc.png" width=400 >

> 11- make sure that the service changed through the next command:



kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

#--------------------------------------------------------------------------------------------------------------------###################################################################
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
