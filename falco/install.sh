#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="falco"
RULES_FILE="$(dirname "$0")/rules.yaml"
VALUES_FILE="$(dirname "$0")/values.yaml"

helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap falco-custom-rules \
  --from-file=rules.yaml="${RULES_FILE}" \
  --namespace "${NAMESPACE}" \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install falco falcosecurity/falco \
  --namespace "${NAMESPACE}" \
  --values "${VALUES_FILE}"

echo "Falco deployed in namespace '${NAMESPACE}'"
echo "To watch alerts: kubectl logs -n ${NAMESPACE} -l app.kubernetes.io/name=falco -f"
