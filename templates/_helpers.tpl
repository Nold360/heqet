{{/* Generate VaultSecrets */}}
{{- define "gen.secrets" -}}
{{- $context := . }}
  {{- with $context }}
   {{- range .secrets }}
---
apiVersion: ricoberger.de/v1alpha1
kind: VaultSecret
metadata:
  name: {{ .name }}
  namespace: {{ $context.namespace | default $context.existingNamespace | default $context.name | quote }}
  labels:
    app: {{ $context.name }}
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
spec:
  keys:
{{ toYaml .keys | indent 2}}
  path: heqet/{{ .fromApp | default $context.name }}/{{ .name }}
  type: {{ $context.type | default "Opaque" }}
   {{ end }}
 {{ end }}
{{- end }}

{{/* Generate NetworkPolicies */}}
{{- define "gen.netpol" -}}
{{- $context := .app }}
{{- $netpols := .netpols }}
  {{- with $context }}
    {{- with $netpols }}
      {{- range $context.networkpolicies }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {{ . }}
  namespace: {{ $context.namespace | default $context.existingNamespace | default $context.name | quote }}
  labels:
    app: {{ $context.name }}
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
spec:
{{- if not (hasKey $netpols .) }}
  {{ fail "ERROR: A NetworkPolicy could not be found in defined Values.networkpolicies!" }}
{{- end }}
{{ get $netpols . | toYaml | indent 2 }}
      {{- end }}
    {{- end }}
  {{ end }}
{{- end }}
