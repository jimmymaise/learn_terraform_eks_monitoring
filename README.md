
terraform init
terraform plan -var-file="secret.tfvars" -var-file="environment.tfvars" -out="out.plan"
terraform apply out.plan
curl -o v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
kubectl get deployment metrics-server -n kube-system

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
kubectl apply -f ./kubeyaml/dashboard-adminuser.yaml
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

kubectl proxy

eyJhbGciOiJSUzI1NiIsImtpZCI6ImViY1ZZNjFUbXZ3bkowaXZibXhYUU1GMTFscTEyd2ZpdFcxSmpQU1gwZTQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXZienB4Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJiY2FlNTcyZS0xOTg0LTRiYjAtYjA4Mi0wMDEyYTNkMjAwMjEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.HAIMakAXuQt6MZztF1snLbh4-RoNZFyShD2y1K5OoPy5BfqiP3Pk2goke3HuAJDybF8PxyiFR1VE9HTpXOV_MWOhHUIx87E1hwXeY-lnpsdI7MdoEUgFDd2QarUIjHyLJJH5lbDqAoirtpGjk9WZle8Ao_eIpeD2qnfqhI7FNRXC3nmuh6IQQCPOHhnXYkvrD0mOXpuCCV6Emc6hu0EX3wBoWi94QgJSWUflmAkNih-AfU56NRf93DFIXzhb4FHpwusPPzQTmFDi1Ca2KOt9keUwkeK99NcH0MmJZSTsXdwqnjF4opdfXgciBJvVPJitr9I5QLcKqrIxNgwcYBa3eQ

terraform destroy -var-file="secret.tfvars" -var-file="environment.tfvars"
cloud-nuke aws --exclude-resource-type iam
