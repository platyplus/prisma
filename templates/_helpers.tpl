{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prisma.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prisma.fullname" -}}
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
{{- define "prisma.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "prisma.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Set the proper database host. If postgresql is installed as part of this chart, use k8s service discovery,
else use user-provided host
*/}}
{{- define "prisma.database.host" }}
{{- if .Values.postgresql.enabled -}}
{{- include "prisma.postgresql.fullname" . }}
{{- else -}}
{{- .Values.database.host }}
{{- end -}}
{{- end -}}

{{/*
Set the proper database name. If postgresql is installed as part of this chart, use k8s service discovery,
else use user-provided host
*/}}
{{- define "prisma.database.name" }}
{{- if .Values.postgresql.enabled -}}
{{- default "prisma" .Values.postgresql.service.name }}
{{- else -}}
{{- .Values.database.name }}
{{- end -}}
{{- end -}}

{{/*
Set the proper database port. If postgresql is installed as part of this chart, use the default postgresql port,
else use user-provided port
*/}}
{{- define "prisma.database.port" }}
{{- if .Values.postgresql.enabled -}}
{{- default "5432" .Values.postgresql.service.port }}
{{- else -}}
{{- .Values.database.port }}
{{- end -}}
{{- end -}}}
