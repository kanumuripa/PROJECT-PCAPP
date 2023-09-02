#This will take around 15 to 20min to create infra(installation of CSI driver will take around 12min and this required for prometheus).

NOTE1: I think some of the services I used won't cover under AWS FREE tier. You can expect some charges for EKS,EC2 T3.Medium for nodes, RDS, NAT GW, IGW and other storages etc.

NOTE2: I used RDS instead of Mysql Kubernetes pods
(I tested using a single Mysql POD with a petclinic app and it worked. 
still working on Mysql replication. I will update this if i can succeed with installation of innodb-mysql replication).

NOTE3: Load balancers and PV/PVC/SC(for safe side) we create from kubectl need to be deleted manually using kubectl commands or from AWS console. 
       Because these are created using kubectl and the terraform state file doesn't have any info about them.  
       we can include this to terraform destroy by using terraform data source(Will update once i tested).

NOTE4: you need to edit yaml files according to your docker images. If you use rds then deploy only secret.yaml from the mysql folder.

# I didn't clone "EC-ssh.pem"(update eks.tf and ec2.tf with your pem file) and "ansible.yaml" files. You need to create.

1. EC2-ssh.pem ...from AWS account create pem file and copy it to file. this will help you to login to ec2 server and connecting to other nodes.

2. ansible.yaml, below is a yaml file example, you need to update AWS ACCESS KEY ID and SECRET. 
   This will help to perform kubectl commands without any manual interaction.

- name: aws configure
  hosts: localhost
  tasks:
    - name: aws config run
      expect:
        command: aws configure
        responses:
           AWS Access Key ID: <"Z5UNKFHP3BGTXU"> #update with your ID
           AWS Secret Access Key: <"DKWWcF5Wym7aDt86biejQUZ">  #update with your key
           Default region name: "us-east-1"
           Default output format: "json"
      no_log: true


3. 1.vpc.tf will create VPC in us-east-1, subnets in 2 AZ's(1a and 1b) with Public and Private subnets, Routes, IGW, NAT GW and route table association.

4. 2.sg.tf will open ports for http,https, and others

5. 3.eks.tf contains eks and node configuration

4. 4.ec2.tf will create an ec2 instance with ubuntu AMI, we can use it as a bastion host. ec2.sh script will install all softwares required in this node. 
   Like aws cli, eks, kubectl, mysql client and so on...

5. 6.mysql-rds.tf, this will create an rds instance(If you don't need RDS and want to use k8s Mysql pods, then comment this part). 
   this will create mysql rds, "petclinic" DB with user and password as "petclinic" port 3306

6. argo.sh and pro-grafana.sh will install argocd, prometheus and grafana helm packages and bring up service

7. tf file starting with 8, 9 and 10 will create oidc and IAM role and Install CSI Driver --> this configuration is required for EBS, EFS and Prometheus.

once installation is finished you can login to argo cd and grafana UI(run "kubectl get svc -ALL" to find out service url's)

Argo CD: admin and password will print on console you can check for "##ARGO UI Secret PASSWORD#" or use below command...
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep "password" | echo `cut -d: -f2` | base64 -d 

Grafana user name and password are admin/admin@321  
--> I used 17119 dashboard id for EKS cluster, this dashboard created for EKS in grafana preconfigured dashboards.

steps to login to ec2 instance:

from putty or terminal:

ssh -i /home/bhavyasri/EC2-ssh.pem ubuntu@<ec2 public IP>

cd /home/ubuntu
#run below ansible playbook to updated aws configure
ansible-playbook ansible.yaml

# run below to switch context
aws eks --region <us-east-1> update-kubeconfig --name <eks-cluster-1>