~~3119 6417


aws s3api create-bucket --bucket dev-eks-monitoring-pet-backend --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2

export ENV="dev"

terraform init -backend-config=envs/${ENV}/backend.conf

terraform apply -var-file=envs/${ENV}/terraform.tfvars

terraform destroy -var-file=envs/${ENV}/terraform.tfvars


aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
kubectl apply -f ./kubeyaml/dashboard-adminuser.yaml kubectl -n kubernetes-dashboard get secret $(kubectl -n
kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

kubectl proxy

cloud-nuke aws --exclude-resource-type iam

export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "http://$ELB"
justForTest



kubectl get hpa

kubectl run -i     --tty load-generator     --rm --image=busybox     --restart=Never     -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"

kubectl run -i     --tty load-generator1     --rm --image=busybox     --restart=Never     -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"
kubectl run -i     --tty load-generator2     --rm --image=busybox     --restart=Never     -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"

kubectl run -i     --tty load-generator3     --rm --image=busybox     --restart=Never     -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"
kubectl run -i     --tty load-generator4     --rm --image=busybox     --restart=Never     -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"

kubectl run -i     --tty load-generator5     --rm --image=busybox     --restart=Never     -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"
kubectl run -i     --tty load-generator6     --rm --image=busybox     --restart=Never     -- /bin/sh -c "while sleep 0.001; do wget -q -O- http://quote-fe-v1; done"

