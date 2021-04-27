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
  podSelector: {}
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
{{- if .allow.fromApps }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: heqet-netpolicy-app-fromapps-{{ .name }}
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
  policyTypes:
  - Ingress
  podSelector: {}
{{- end }}
{{- if .allow.ingress }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: heqet-netpolicy-app-ingress-{{ .name }}
  namespace: {{ .namespace | default .name }}
  labels: 
    app.heqet.gnu.one/name: {{ .name }}
spec:
  ingress:
  - ports:
{{- range .allow.ingress }}
    - port: {{ .port }}
      protocol: {{ .protocol | default "TCP" }}
{{- end }}
  policyTypes:
  - Ingress
  podSelector: {}
{{- end }}

{{- if .allow.egress }}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: heqet-netpolicy-app-egress-{{ .name }}
  namespace: {{ .namespace | default .name }}
  labels: 
    app.heqet.gnu.one/name: {{ .name }}
spec:
  egress: 
  - ports:
{{- range .allow.egress }}
    - port: {{ .port }}
      protocol: {{ .protocol | default "TCP" }}
{{- end }}
  policyTypes:
  - Egress
  podSelector: {}
  {{- end }}
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
