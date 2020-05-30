{{- /*
  Heket's Auto TLS Ingress Injector [ATIC]:
*/ -}}
{{- define "heqet.ingress" }}
ingress:
  enabled: true
  hosts:
  {{- if not .ingress_hosts_keymap }}
    - {{ required "You need to set a domain for your app or disable atic" .domain }}
  {{- else }}
    - host: {{ required "You need to set a domain for your app or disable atic" .domain }}
      paths: []
  {{- end }}
  annotations:
    kubernetes.io/ingress.class: {{ .ingress_class | default "nginx" }}
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: {{ .ingress_cluster_issuer | default "letsencrypt" }}
  tls:
    - secretName: {{ .name }}-le-tls
      hosts:
        - {{ .domain | quote }}
{{- end }}
