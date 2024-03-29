{{/* Main Template generating ArgoCD Apps */}}
{{- define "heqet.template.app" }}
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ .name | quote }}
  namespace: argocd
  labels:
    app.heqet.gnu.one/name: {{ .name }}
    app.heqet.gnu.one/project: {{ .project }}
    app.kubernetes.io/name: {{ .name }}
    app.kubernetes.io/part-of: heqet
	{{- with .labels }}{{ toYaml . | nindent 4}}{{ end }}
  annotations:
    argocd.argoproj.io/sync-wave: {{ .syncWave | default "0" | quote }}
	{{- with .annotations }}{{ toYaml . | nindent 4}}{{ end }}
spec:
  project: {{ .project }}
  destination:
    namespace: {{ .namespace }}
    server: {{ .server }}
  source:
    path: {{ .path | default "" | quote }}
    repoURL: {{ .repoURL | quote }}
    targetRevision: {{ .targetRevision | quote }}
  {{- with .chart }}
    chart: {{ . | quote }}
  {{- end }}
    helm:
      {{- with .parameters }}
      parameters:
				{{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .values }}
      values: |
				{{- toYaml . | nindent 8 }}
      {{- end }}
  {{- with .automated }}
  syncPolicy:
    automated:
      prune: {{ .prune | default "false"  }}
      selfHeal: {{ .selfHeal | default "false" }}
  {{- end }}
	{{- with .ignoreDiff }}
  ignoreDifferences:
    {{ .ignoreDiff | toYaml | nindent 4 }}
	{{- end }}
{{- with .secrets }}{{- include "heqet.template.secrets" $ }}{{- end }}
{{- end }}
