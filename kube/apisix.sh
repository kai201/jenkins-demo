helm install apisix apisix/apisix \
  --set gateway.type=NodePort \
  --set ingress-controller.enabled=true \
  --set dashboard.enabled=true \
  --namespace kube-apisix \
  --set ingress-controller.config.apisix.serviceNamespace=kube-apisix \
  --kubeconfig /etc/rancher/k3s/k3s.yaml