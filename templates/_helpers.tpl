{{ required .Values.name  }}
{{ required .Values.env  }}
{{/*
Expand the name of the chart.
*/}}
{{- define "hct.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hct.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hct.labels" -}}
app: {{ include "hct.name" .}}
helm.sh/chart: {{ include "hct.chart" . }}
{{ include "hct.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hct.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hct.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hct.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hct.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Helper  template functions for environmental variables
*/}}

{{- define "replicaCount" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.replicaCount.dev }}{{ end }}
{{- if eq .Values.env  "int" }}{{ .Values.replicaCount.int }}{{ end }}
{{- if eq .Values.env  "uat" }}{{ .Values.replicaCount.uat }}{{ end }}
{{- if eq .Values.env  "prod" }}{{ .Values.replicaCount.prod }}
{{- else }} {{.Values.replicaCount.dev }} {{ end }}
{{- end }}

{{- define "minReplicas" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.minReplicas.dev }}{{ end }}
{{- if eq .Values.env  "int" }}{{ .Values.autoscaling.minReplicas.int }}{{ end }}
{{- if eq .Values.env  "uat" }}{{ .Values.autoscaling.minReplicas.uat }}{{ end }}
{{- if eq .Values.env  "prod" }}{{ .Values.autoscaling.minReplicas.prod }}
{{- else }}{{ .Values.autoscaling.minReplicas.dev }}{{ end }}
{{- end }}

{{- define "maxReplicas" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.maxReplicas.dev }}{{ end }}
{{- if eq .Values.env  "int" }}{{ .Values.autoscaling.maxReplicas.int }}{{ end }}
{{- if eq .Values.env  "uat" }}{{ .Values.autoscaling.maxReplicas.uat }}{{ end }}
{{- if eq .Values.env  "prod" }}{{ .Values.autoscaling.maxReplicas.prod }}
{{- else }}{{ .Values.autoscaling.maxReplicas.dev }}{{ end }}
{{- end }}

{{- define "targetMemoryUtilizationPercentage" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.dev }}{{ end }}
{{- if eq .Values.env  "int" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.int }}{{ end }}
{{- if eq .Values.env  "uat" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.uat }}{{ end }}
{{- if eq .Values.env  "prod" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.prod }}
{{- else }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.dev }}{{ end }}
{{- end }}

{{- define "targetCPUUtilizationPercentage" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.dev }}{{ end }}
{{- if eq .Values.env  "int" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.int }}{{ end }}
{{- if eq .Values.env  "uat" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.uat }}{{ end }}
{{- if eq .Values.env  "prod" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.prod }}
{{- else }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.dev }}{{ end }}
{{- end }}

{{- define "resources" -}}
{{- if eq .Values.env  "dev" }}{{- toYaml .Values.resources.dev | nindent 12 }}{{ end }}
{{- if eq .Values.env  "int" }}{{- toYaml .Values.resources.int | nindent 12 }}{{ end }}
{{- if eq .Values.env  "uat" }}{{- toYaml .Values.resources.uat | nindent 12 }}{{ end }}
{{- if eq .Values.env  "prod" }}{{- toYaml .Values.resources.prod | nindent 12 }}
{{- else }} {{- toYaml .Values.resources.dev | nindent 12}}{{ end }}
{{- end }}