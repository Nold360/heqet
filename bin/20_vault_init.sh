#!/bin/bash
# Generate Vault Service-Account for Apps & preseed data
function v {
  echo "vault $@"
  kubectl exec -it vault-0 -n vault -- vault $@
}

v auth enable kubernetes
v write auth/kubernetes/config \
        token_reviewer_jwt="\$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_host="https://\${KUBERNETES_PORT_443_TCP_ADDR}:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

v secrets enable -path=heqet kv-v2

v policy write "heqet-app" - <<EOF
path "heqet/*/*" {
  capabilities = ["read"]
}
EOF

v write auth/kubernetes/role/heqet-app \
  bound_service_account_names=vault-secrets-operator \
  bound_service_account_namespaces=vault-secrets-operator \
  policies=heqet-app \
  ttl=6h

# Passwort: argocd
v kv put heqet/argocd/argocd-secret admin.password='$2y$12$FP8OlsVj5pOOqRAhI4XPoev1STaW01uUEZGcNPQtVZmpacebNhj9i' server.secretkey="pDYAWK2mHa68GwwVPAsQOsG/SUT8iIo3S3FXYUWf2qM="
