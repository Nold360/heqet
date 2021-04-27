{{/* Generate NetworkPolicies */}}
{{- define "gen.netpolicy" -}}
{{- $context := .context }}
{{- $defaults := .defaults }}
  {{- with $defaults }}
  {{- with $context }}
---
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: heqet-namespace-isolation-{{ .name }}
  namespace: {{ .namespace | default .name }}
  labels:
    app.heqet.gnu.one/name: {{ .name }}
spec:
  podSelector:
    matchLabels:
  ingress:
  - from:
    - podSelector: {}
    {{- if $defaults }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: heqet-netpolicy-default-{{ .name }}
  namespace: {{ .namespace | default .name }}
  labels:
    app.heqet.gnu.one/name: {{ .name }}
spec:
{{- if $defaults.ingress }}
  ingress:
{{ toYaml $defaults.ingress | indent 2 }}
{{- end }}
{{- if $defaults.egress }}
  egress:
{{ toYaml $defaults.egress | indent 2 }}
{{- end }}
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
{{- end }}

{{- if .allow }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: heqet-netpolicy-app-{{ .name }}
  namespace: {{ .namespace | default .name }}
  labels: 
    app.heqet.gnu.one/name: {{ .name }}
spec:
  ingress:
  - from:
  {{- range .allow.fromApps }}
    - namespaceSelector:
        matchLabels:
          app.heqet.gnu.one/name: {{ . }} 
      podSelector: {}
   {{- end }}
{{- if .allow.ingress }}
  - ports:
  {{- range .allow.ingress }}
    - port: {{ . }}
      from:
        - podSelector: {}
  {{- end }}
{{- end }}

{{- if .allow.egress }}
  egress: 
{{- range .allow.egress }}
  - ports:
    - port: {{ . }}
{{- end }}
{{- end }}
  policyTypes:
  - Ingress
  - Egress
  podSelector: {}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}

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
  namespace: {{ $context.namespace | default $context.name | quote }}
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
