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
