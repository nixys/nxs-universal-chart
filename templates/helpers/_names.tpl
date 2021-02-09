{{- define "helpers.app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helpers.app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helpers.app.fullname" -}}
{{- $values := .context.Values -}}
{{- $release := .context.Release -}}
{{- $chart := .context.Chart -}}
{{- if .name -}}
{{- if $values.fullnameOverride -}}
{{- $values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $appName := (include "helpers.app.name" .context) -}}
{{- if contains $appName $release.Name -}}
{{- printf "%s-%s" $release.Name .name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" $release.Name .name $appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- else -}}
{{- if $values.fullnameOverride -}}
{{- $values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $appName := (include "helpers.app.name" .context) -}}
{{- if contains $appName $release.Name -}}
{{- $release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $release.Name $appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
