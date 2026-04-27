#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="hello-world"
SA="sa-deployer"
CONTEXT="fort-kn8x"
OUTPUT="kubeconfig-${SA}.yaml"

CLUSTER_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CLUSTER_CA=$(kubectl config view --minify --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')

TOKEN=$(kubectl create token "${SA}" --namespace "${NAMESPACE}" --duration=8760h)

cat > "${OUTPUT}" <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${CLUSTER_SERVER}
  name: ${CONTEXT}
contexts:
- context:
    cluster: ${CONTEXT}
    namespace: ${NAMESPACE}
    user: ${SA}
  name: ${CONTEXT}
current-context: ${CONTEXT}
users:
- name: ${SA}
  user:
    token: ${TOKEN}
EOF

echo "Kubeconfig généré : ${OUTPUT}"
