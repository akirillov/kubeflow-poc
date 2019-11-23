#!/bin/bash

PATH=$PATH:$HOME/dev/bin/kfctl
KF_NAME=kf-demo
BASE_DIR="$(realpath "$(dirname "$0")")"
KF_DIR=${BASE_DIR}/${KF_NAME}
CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v0.7-branch/kfdef/kfctl_k8s_istio.0.7.0.yaml"


# INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
# SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
# INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')

rm -rf ${KF_DIR} && mkdir -p ${KF_DIR}
pushd ${KF_DIR}
kfctl apply -V -f ${CONFIG_URI}
popd

kubectl -n kubeflow get all

echo
echo "Run the following command to forward ports from Istio gateway:"
echo "kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80"

echo "To discover API server address run:"
echo "kubectl config view --minify | grep server"
