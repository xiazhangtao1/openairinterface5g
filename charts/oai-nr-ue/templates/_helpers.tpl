{{/*
Expand the name of the chart.
*/}}
{{- define "oai-nr-ue.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "oai-nr-ue.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oai-nr-ue.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "oai-nr-ue.labels" -}}
helm.sh/chart: {{ include "oai-nr-ue.chart" . }}
{{ include "oai-nr-ue.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "oai-nr-ue.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oai-nr-ue.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use.
*/}}
{{- define "oai-nr-ue.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "oai-nr-ue.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Render command-line options as a shell-safe space-delimited string.
*/}}
{{- define "oai-nr-ue.additionalOptions" -}}
{{- $options := list -}}
{{- range .Values.additionalOptions -}}
{{- $options = append $options . -}}
{{- end -}}
{{- $options = append $options "-r" -}}
{{- $options = append $options (toString .Values.radio.prb) -}}
{{- $options = append $options "--numerology" -}}
{{- $options = append $options (toString .Values.radio.numerology) -}}
{{- $options = append $options "--band" -}}
{{- $options = append $options (toString .Values.radio.band) -}}
{{- $options = append $options "-C" -}}
{{- $options = append $options (toString .Values.radio.frequency) -}}
{{- $options = append $options "--rfsimulator.serveraddr" -}}
{{- $options = append $options (toString .Values.rfsimulator.serveraddr) -}}
{{- range $index, $option := $options -}}{{ if $index }} {{ end }}{{ $option }}{{- end -}}
{{- end -}}
