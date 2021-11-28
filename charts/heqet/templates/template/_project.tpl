{{- define "heqet.template.project" }}
---
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: {{ .name }}
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "-10"
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  description: {{ .description | default "Application Project" }}
  {{- .spec | toYaml | nindent 2 }}
{{- end }}
