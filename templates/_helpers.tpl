
{{ required .Values.name  }}
{{ required .Values.env  }}
{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
app: {{ include "app.name" .}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Helper  template functions for environmental variables
*/}}

{{- define "replicaCount" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.replicaCount.dev }}
{{- else if eq .Values.env  "int" }}{{ .Values.replicaCount.int }}
{{- else if eq .Values.env  "uat" }}{{ .Values.replicaCount.uat }}
{{- else if eq .Values.env  "prod" }}{{ .Values.replicaCount.prod }}
{{- else }} {{.Values.replicaCount.dev }} {{ end }}
{{- end }}

{{- define "minReplicas" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.minReplicas.dev }}
{{- else if eq .Values.env  "int" }}{{ .Values.autoscaling.minReplicas.int }}
{{- else if eq .Values.env  "uat" }}{{ .Values.autoscaling.minReplicas.uat }}
{{- else if eq .Values.env  "prod" }}{{ .Values.autoscaling.minReplicas.prod }}
{{- else }}{{ .Values.autoscaling.minReplicas.dev }}{{- end }}
{{- end -}}

{{- define "maxReplicas" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.maxReplicas.dev }}
{{- else if eq .Values.env  "int" }}{{ .Values.autoscaling.maxReplicas.int }}
{{- else if eq .Values.env  "uat" }}{{ .Values.autoscaling.maxReplicas.uat }}
{{- else if eq .Values.env  "prod" }}{{ .Values.autoscaling.maxReplicas.prod }}
{{- else }}{{ .Values.autoscaling.maxReplicas.dev }}{{ end }}
{{- end }}

{{- define "targetMemoryUtilizationPercentage" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.dev }}
{{- else if eq .Values.env  "int" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.int }}
{{- else if eq .Values.env  "uat" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.uat }}
{{- else if eq .Values.env  "prod" }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.prod }}
{{- else }}{{ .Values.autoscaling.targetMemoryUtilizationPercentage.dev }}{{ end }}
{{- end }}

{{- define "targetCPUUtilizationPercentage" -}}
{{- if eq .Values.env  "dev" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.dev }}
{{- else if eq .Values.env  "int" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.int }}
{{- else if eq .Values.env  "uat" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.uat }}
{{- else if eq .Values.env  "prod" }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.prod }}
{{- else }}{{ .Values.autoscaling.targetCPUUtilizationPercentage.dev }}{{ end }}
{{- end }}

{{- define "resources" -}}
{{- if eq .Values.env  "dev" }}{{- toYaml .Values.resources.dev | nindent 12 }}
{{- else if eq .Values.env  "int" }}{{- toYaml .Values.resources.int | nindent 12 }}
{{- else if eq .Values.env  "uat" }}{{- toYaml .Values.resources.uat | nindent 12 }}
{{- else if eq .Values.env  "prod" }}{{- toYaml .Values.resources.prod | nindent 12 }}
{{- else }} {{- toYaml .Values.resources.dev | nindent 12}}{{ end }}
{{- end }}

{{- define "volumes" -}}
{{- if .Values.config.enabled }}
  - name: config-volume
    configMap:
      name: {{ include "configmap.name" .}}
      {{- if .Values.config.resources }}
      items: 
      {{- range .Values.config.resources }}
      {{- if eq .mountAs "file" }}
        - key: {{ .name }}
          path: "{{ .name }}" 
      {{- end }}
      {{- end }}
      {{- end }}
{{- end -}}
{{- if .Values.secrets.enabled }}
  - name: secrets-volume
    secret:
      secretName: {{ include "secrets.creds.name" .}}
      {{- if .Values.secrets.resources }}
      items: 
      {{- range .Values.secrets.resources }}
      {{- if eq .mountAs "file" }}
        - key: {{ .name }}
          path: "{{ .name }}" 
      {{- end }}
      {{- end }}
      {{- end  }}
{{- end -}}
{{- if .Values.certs.enabled }}
  - name: certs-volume
    secret:
      secretName: {{ include "secrets.certs.name" .}}
      {{- if .Values.certs.resources }}
      items: 
      {{- range .Values.certs.resources }}
      {{- if eq .mountAs "file" }}
        - key: {{ .name }}
          path: "{{ .name }}" 
      {{- end }}
      {{- end }}
      {{- end }}
{{- end -}}
{{- end -}}

{{- define "volumeMounts" -}}
{{- if .Values.config.enabled }}
  - name: config-volume
    mountPath: {{ .Values.config.mountPath }}
{{- end }}
{{- if .Values.certs.enabled }}
  - name: certs-volume
    mountPath: {{ .Values.certs.mountPath }}
{{- end }}
{{- if .Values.secrets.enabled }}
  - name: secrets-volume
    mountPath: {{ .Values.secrets.mountPath }}
{{- end }}
{{- end -}}

{{- define "configmap.name" -}}
{{ .Values.env }}-{{ include  "app.name" . }}-configmap
{{- end -}}

{{- define "secrets.certs.name" -}}
{{ .Values.env }}-{{ include  "app.name" . }}-secrets-certs
{{- end -}}

{{- define "secrets.creds.name" -}}
{{ .Values.env }}-{{ include  "app.name" . }}-secrets-creds
{{- end -}}