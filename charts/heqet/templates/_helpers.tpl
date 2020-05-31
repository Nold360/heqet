{{- /*
  Heket's Auto TLS Ingress Injector [ATIC]:
*/ -}}
{{- define "heqet.ingress" }}
ingress:
  enabled: true
  hosts:
  {{- if not .ingress_hosts_keymap }}
    - {{ required "You need to set a domain for your app or disable atic" .vhost }}
  {{- else }}
    - host: {{ required "You need to set a domain for your app or disable atic" .vhost }}
      paths: []
  {{- end }}
  annotations:
    kubernetes.io/ingress.class: {{ .ingress_class | default "nginx" }}
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: {{ .ingress_cluster_issuer | default "letsencrypt" }}
  tls:
    - secretName: {{ .name }}-le-tls
      hosts:
        - {{ .vhost | quote }}
{{- end }}
{{- /*
  Read value files for every application
*/ -}}
{{- define "app.values" }}
  {{- $values := .Files.Glob "values.d/*.yaml" }}
{{- ($values)| indent 8 }}
{{ end }}

{{- /*
  Inject vault-injector into pods
*/ -}}
{{- define "heqet.vault" }}
podAnnotations:
  heqet.gnu.one/app: "true"
  vault.hashicorp.com/agent-inject: "true"
  vault.hashicorp.com/role: "{{ .name }}-vault-ro"
  {{- if .secret }}
    {{- $appname := .name }}
    {{- range .secrets }}
  vault.hashicorp.com/agent-inject-secret-{{ .path }}: "heqet/apps/{{ $appname }}/{{ .name }}"
    {{- end }}
  {{- end }}
spec:
  serviceAccountName: "{{ .name }}-vault-ro"
{{- end }}
