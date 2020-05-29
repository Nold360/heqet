{{- /*
  Heket's Auto TLS Ingress Injector [ATIC]:
*/ -}}
{{- define "heqet.ingress" }}
ingress:
  enabled: true
  hosts:
    - {{ required "You need to set a domain for your app or disable atic" .domain }}
  annotations:
    kubernetes.io/ingress.class: {{ .ingress_class | default "nginx" }}
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: {{ .ingress_cluster_issuer | default "letsencrypt" }}
  tls:
    - secretName: {{ .name }}-le-tls
      hosts:
        - {{ .domain }}
{{- end }}
