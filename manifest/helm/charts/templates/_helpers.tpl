{{/*
Expand the name of the chart.
*/}}
{{- define "kubera-propel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubera-propel.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubera-propel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for deployment
*/}}
{{- define "kubera-propel.chartMetaLabel" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Common labels for propel-webapp
*/}}
{{- define "kubera-propel.webApp.labels" -}}
{{ include "kubera-propel.webApp.matchLabels" . }}
{{ include "kubera-propel.chartMetaLabel" . }}
{{- end }}

{{/*
match-labels for propel-webapp
*/}}
{{- define "kubera-propel.webApp.matchLabels" -}}
propel.kubera.mayadata.io/app-name: {{ .Values.webApp.componentName }}
propel.kubera.mayadata.io/is-server: "true"
{{- end }}

{{/*
Common labels for server deployment
*/}}
{{- define "kubera-propel.server.labels" -}}
{{ include "kubera-propel.server.matchLabels" . }}
{{ include "kubera-propel.chartMetaLabel" . }}
{{- end }}

{{/*
common match-labels for server deployment
*/}}
{{- define "kubera-propel.server.matchLabels" -}}
propel.kubera.mayadata.io/app-name: {{ .Values.server.componentName }}
propel.kubera.mayadata.io/is-server: "true"
{{- end }}

{{/*
labels for ingress
*/}}
{{- define "kubera-propel.ingress.labels" -}}
propel.kubera.mayadata.io/is-server: "true"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubera-propel.serviceAccountName" -}}
{{- if .Values.serviceAccount.propel.create }}
{{- default (include "kubera-propel.fullname" .) .Values.serviceAccount.propel.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.propel.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress.
apiVersion will be picked according to the below priority
1. networking.k8s.io/v1/ingress (K8s version >= 1.9.0)
2. networking.k8s.io/v1beta1 (K8s version >= 1.14.0)
3. networking.k8s.io/v1beta1 (K8s version < 1.14.0)
*/}}
{{- define "kubera-propel.ingressAPIVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1/ingress" -}}
{{- print "networking.k8s.io/v1" -}}
{{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}
