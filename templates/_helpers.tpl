{{- /*
  Heqet's Auto TLS Ingress Injector [ATIC]:
*/ -}}
{{- define "heqet.ingress" }}
{{- if .vhost }}
ingress:
  enabled: true
  hosts:
  {{- if not .ingressHostsKeymap }}
    - {{ required "You need to set a domain for your app or disable atic" .vhost }}
  {{- else }}
    - host: {{ required "You need to set a domain for your app or disable atic" .vhost }}
      paths: []
  {{- end }}
  annotations:
    external-dns.alpha.kubernetes.io/hostname: {{ .vhost }}
  {{- end -}}
{{- end -}}

{{- /*
  Read value files for every application
*/ -}}
{{- define "app.values" }}
  {{- $values := $.Files.Get (printf "values.d/%s.yaml" .name ) | fromYaml }}
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
  {{- if .secrets }}
    {{- $app := . }}
    {{- range .secrets }}
    {{- with $app }}
  vault.hashicorp.com/agent-inject-secret-{{ .path |replace "/" "-" }}: "heqet/apps/{{ $app.name }}/{{ .name }}"
    {{- end }}
    {{- end }}
  {{- end }}
spec:
  serviceAccountName: "{{ .name }}-vault-ro"
{{- end -}}

{{- define "heqet.patch" }}
  {{- if .root }}
    {{- dict .root .patchValues | toYaml }}
  {{- else }}
    {{- toYaml .patchValues }}
  {{- end }}
{{- end }}
