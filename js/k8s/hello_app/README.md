# Hello App

Simple containerised app with minimal dependencies to allow deployments to container management platforms for verification.

## To build container image

docker build -y hello_app .

## Running

docker run -p 3000:3000 hello_app

# Deploy to Kubernetes cluster

kubectl apply -f test_deploy.y

## Remove all old docker containers using specific image

docker rm -f `docker container ls -a --format 'table {{.ID}}\t{{.Image}}\t{{.Names}}' | grep '<IMAGE_NAME>' | cut -f 1 -d ' '`

# Expose deployment to internal cluster
kubectl expose deployment myhello --type=ClusterIP --name=hello-service

# Port forward to allow access
kubectl port-forward service/hello-service 3000:3000

# Create mandatory nginx ingress resources in the cluster
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/baremetal/deploy.yaml

# Check setup
kubectl get pods --all-namespaces
kubectl get pods -n ingress-nginx

## Verify kbinx version
Exec into the controller pod and run following if you want to verify

kubectl exec -it -n ingress-nginx <ingress-nginx-controller-randomID-podname> -- bash
/nginx-ingress-controller --version

# Debugging cluster setup
https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

# Deleting nginx if required
kubectl delete namespace ingress-nginx
kubectl delete clusterrole ingress-nginx
kubectl delete clusterrolebinding ingress-nginx
kubectl delete ValidatingWebhookConfiguration ingress-nginx-admission

# Install MetalLB to let nginx get given an external IP address

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml

# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# Define and deploy and configmap

apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.27.240-192.168.27.250

# Install Helm for nginx
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add nginx-stable https://helm.nginx.com/stable
kubectl create namespace ingress-nginx
helm install -n ingress-nginx <your-own-release-name> nginx-stable/nginx-ingress

# Show external IP allocated to nginx ingress
kubectl get svc -n ingress-nginx

# Run interactive Linux pod to verify networking etc
kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh