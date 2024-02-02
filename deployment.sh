#!/bin/bash

# set context to application-cluster
KUBE_CONTEXT="kind-application-cluster"
kubectl config use-context "$KUBE_CONTEXT"

# create postgresql  namespace if not present
POSTGRESQL_NAMESPACE="postgresql"
kubectl get ns "$POSTGRESQL_NAMESPACE" || kubectl create ns "$POSTGRESQL_NAMESPACE"

# install OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

# deploy postgresql operator from operatorhub manifests
echo "deploy postgresql operator..."
kubectl create -f https://operatorhub.io/install/postgres-operator.yaml

# deploy postgresql crds
kubectl apply -f configs/employee-postgresql-db.yaml -n "$POSTGRESQL_NAMESPACE"
kubectl apply -f configs/performance-postgresql-db.yaml -n "$POSTGRESQL_NAMESPACE"

echo "PostgreSQL and CRDs deployed successfully in namespace '$POSTGRESQL_NAMESPACE' of context '$KUBE_CONTEXT'."