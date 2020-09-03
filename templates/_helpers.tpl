{{/*
Expand the name of the chart.
*/}}
{{- define "test.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "test.fullname" -}}
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
{{- define "test.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "test.labels" -}}
helm.sh/chart: {{ include "test.chart" . }}
{{ include "test.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "test.selectorLabels" -}}
app.kubernetes.io/name: {{ include "test.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "test.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "test.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Generate certificates for secret server
*/}}
{{- define "test.gen-certs" -}}
{{- $test := include "gen-altnames-vars" $ -}}
{{- $test2 := $test | trimSuffix "," | splitList "," -}}
{{- $test3 := (list "server1" "server2") -}}
{{- $test4 := $test2 | join "," -}}
{{- $altNames := list (typeOf $test3) -}}
{{- $ca := genCA "Secret" 365 -}}
{{- $server := genSignedCert "" nil $test3 365 $ca -}}
{{- $client := genSignedCert "" nil nil 365 $ca -}}
ca.crt: {{ $ca.Cert | b64enc }}
ca.key: {{ $ca.Key | b64enc }}
tls.crt: {{ $server.Cert | b64enc }}
tls.key: {{ $server.Key | b64enc }}
client.crt: {{ $client.Cert | b64enc }}
client.key: {{ $client.Key | b64enc }}
aa_:
aa_: TEST 1
aa_: ------
aa_plain: OUTPUT   {{ $test }}
aa_printf: TYPE     {{ printf "%t" $test }}
aa_kind: KIND     {{ kindOf $test }}
aa_kind: TYPEOF   {{ typeOf $test }}
aa_:
aa_: TEST 2
aa_: ------
aa_plain: OUTPUT   {{ $test }}
aa_printf: TYPE     {{ printf "%t" $test2 }}
aa_kind: KIND     {{ kindOf $test2 }}
aa_kind: TYPEOF   {{ typeOf $test2 }}
aa_:
aa_: TEST 3 - CORRECT
aa_: ------
aa_plain: OUTPUT   {{ $test3 }}
aa_printf: TYPE     {{ printf "%t" $test3 }}
aa_kind: KIND     {{ kindOf $test3 }}
aa_kind: TYPEOF   {{ typeOf $test3 }}
aa_:
aa_: TEST 4
aa_: ------
aa_plain: OUTPUT   {{ $test4 }}
aa_printf: TYPE     {{ printf "%t" $test4 }}
aa_kind: KIND     {{ kindOf $test4 }}
aa_kind: TYPEOF   {{ typeOf $test4 }}
{{- end -}}

{{/* Generates a list of altNames */}}
{{- define "gen-altnames-vars" -}}
{{- range $i := until 5 }}{{ $.Release.Name }}-{{ $.Chart.Name }}-{{$i}},{{ end }}
{{- end }}

{{- define "gen-altnames" -}}
{{- $l := list (include "gen-altnames-vars" ) -}}
{{- slice $l -}}
{{- end }}