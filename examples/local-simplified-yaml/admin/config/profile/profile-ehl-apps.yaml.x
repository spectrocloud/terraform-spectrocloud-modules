name: ehl-apps
description: ""
type: add-on
packs:
- name: ehl-generic
  type: manifest
  layer: addon
  registry: helm-blr-ees
  manifests:
  - name: namespaces
    content: |-
      ---
      ###########################
      # NAME SPACES CREATION
      ############################
      apiVersion: v1
      kind: Namespace
      metadata:
        name: edison-system
      ---
      apiVersion: v1
      kind: Namespace
      metadata:
        name: ehl-control-pplane
      ---
      apiVersion: v1
      kind: Namespace
      metadata:
        name: edison-core
      ---
      apiVersion: v1
      kind: Namespace
      metadata:
        name: edison-policy
      ---
      apiVersion: v1
      kind: Namespace
      metadata:
        name: kubeaddons
      ---
      apiVersion: v1
      kind: Namespace
      metadata:
        name: edison-priority-scheduler
      ---
  - name: configmap
    content: |-
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: ehl-generic-map
        namespace: ehl-control-plane
      data:
        bootstrap_host: 192.168.100.10
        bootstrap_pswd: Minda00$
        bootstrap_user: root
        ehl_version: EHL-2.0-SC-dev
  version: 1.0.0
  values: |-
    pack:
      spectrocloud.com/install-priority: "-100"
- name: ehl-monitoring
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 2.0.1-af15864
  tag: 2.0.1-af15864
  values: |-
    pack:
      namespace: "edison-system"
      spectrocloud.com/install-priority: "110"
      releaseNameOverride:
        ehl-monitoring: ehl-monitoring
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/
            name: ehl-monitoring
            version: 2.0.1-af15864
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/prometheus:v2.22.1
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/prometheus-operator:v0.44.0
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/kube-webhook-certgen:v1.5.2
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/configmap-reload:v0.4.0
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/prometheus-config-reloader:v0.44.0
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/alertmanager:v0.21.0
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/kube-state-metrics:v1.9.7
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/node-exporter:v1.0.1
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-monitoring/chronyntpexporter:2.0.1-af15864
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-monitoring/validationwebhook:2.0.1-af15864
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-monitoring/ext_svc_config:2.0.1-af15864
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/prom-opr/blackbox-exporter:v0.18.0

    external-svc-config:
      enabled: false
- name: ehl-logging
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 0.0.1-9478efa
  tag: 0.0.1-9478efa
  values: |-
    pack:
      namespace: "edison-system"
      spectrocloud.com/install-priority: "120"
      releaseNameOverride:
        ehl-logging: ehl-logging
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/
            name: ehl-logging
            version: 0.0.1-9478efa
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/logging-stack/fluentd:1.12.4-debian-10-r3
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-logging/ehl-alpine-nginx:0.0.1-9478efa
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/logging-stack/fluent-bit-plugin-loki:2.0.0-amd64
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/logging-stack/loki:2.0.0
- name: ehl-monitoring-security
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 0.0.1-30c63f5
  tag: 0.0.1-30c63f5
  values: |-
    pack:
      namespace: "edison-system"
      spectrocloud.com/install-priority: "130"
      releaseNameOverride:
        ehl-monitoring-security: ehl-monitoring-security
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/
            name: ehl-monitoring-security
            version: 0.0.1-30c63f5
- name: ehl-grafana
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 0.0.1-4260767
  tag: 0.0.1-4260767
  values: |-
    pack:
      namespace: "edison-system"
      spectrocloud.com/install-priority: "140"
      releaseNameOverride:
        ehl-grafana: ehl-grafana
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/
            name: ehl-grafana
            version: 0.0.1-4260767
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/logging-stack/grafana:8.3.4
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/logging-stack/k8s-sidecar:1.15.4
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/logging-stack/busybox:1.35.0
- name: sprsnapshot-service
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 1.0.0-a7da622
  tag: 1.0.0-a7da622
  values: |-
    pack:
      namespace: "edison-system"
      releaseNameOverride:
        sprsnapshot-service: ehl-sprsnap-service
      spectrocloud.com/install-priority: "150"
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/
            name: sprsnapshot-service
            version: 1.0.0-a7da622
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-sprsnap-service/ehl-sprsnap-service:1.0.0-a7da622
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-sprsnap-service/ehl-alpine-nginx-sprsnap:1.0.0-a7da622
- name: ehl-metacontroller
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 0.0.1-aa67f86
  tag: 0.0.1-aa67f86
  values: |-
    pack:
      namespace: "edison-system"
      releaseNameOverride:
        ehl-metacontroller: ehl-metacontroller
      spectrocloud.com/install-priority: "170"
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/
            name: ehl-metacontroller
            version: 0.0.1-aa67f86
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/metacontrollerio/metacontroller:v1.0.3
- name: eis-postgres
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 2.0.0-d2433f4
  tag: 2.0.0-d2433f4
  values: |-
    pack:
      namespace: "edison-system"
      releaseNameOverride:
        eis-postgres: eis-common-postgres
      spectrocloud.com/install-priority: "180"
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/
            name: eis-postgres
            version: 2.0.0-d2433f4
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/postgres-operator/acid/postgres-operator:v1.6.0
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/postgres-operator/acid/spilo-12:1.6-p5
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/precheck:2.0.0-d2433f4
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/post_delete_hook:2.0.0-d2433f4
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/wrouesnel/postgres_exporter:v0.8.0
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/postgres_import_export:2.0.0-d2433f4
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/webhook:2.0.0-d2433f4

    postgres-operator:
      enabled: true
    eisDicomRsDb:
      enabled: false
    postgres-import-export:
      enabled: true
    postgres-monitoring:
      enabled: true
    eespostgresaccount:
      enabled: true
- name: edison-priority-scheduler
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 1.0.0-654a62d
  tag: 1.0.0-654a62d
  values: |-
    pack:
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all
            name: edison-priority-scheduler
            version: 1.0.0-654a62d
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/edison-priority-scheduler/edison-priority-scheduler:1.0.0-654a62d
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-redis/redis:6.2.5
          - hc-eu-west-aws-artifactory.cloud.health.ge.com/docker-eis-dev/eps-test-client:latest
      namespace: "edison-priority-scheduler"
      releaseNameOverride:
        edison-priority-scheduler: edison-priority-scheduler
      spectrocloud.com/install-priority: "200"

    global:
      resource_config:
        manual: true
    prometheusRules:
      enabled: false
- name: eis-dicom-postgres--eis-postgres
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 2.0.0-d2433f4
  tag: 2.0.0-d2433f4
  values: "pack:\n  namespace: \"edison-system\"\n  releaseNameOverride:\n    eis-postgres:
    eis-dicom-postgres\n  spectrocloud.com/install-priority: \"700\"\n  spectrocloud.com/display-name:
    \"eis-dicom-postgres\"\n  content:\n     charts:\n      - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all/\n
    \       name: eis-postgres\n        version: 2.0.0-d2433f4\n     images:\n      -
    image: blr-artifactory.cloud.health.ge.com/docker-eis-all/postgres-operator/acid/postgres-operator:v1.6.0\n
    \     - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/postgres-operator/acid/spilo-12:1.6-p5\n
    \     - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/precheck:2.0.0-d2433f4\n
    \     - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/post_delete_hook:2.0.0-d2433f4\n
    \     - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/wrouesnel/postgres_exporter:v0.8.0\n
    \     - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/postgres_import_export:2.0.0-d2433f4\n
    \     - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/eis-postgres/webhook:2.0.0-d2433f4
    \n  \n  postgres-operator:\n    enabled: false\n  eisDicomRsDb:\n    enabled:
    true\n  postgres-import-export:\n    enabled: false\n  postgres-monitoring:\n
    \   enabled: false\n  eespostgresaccount:\n    enabled: false"
cloudType: all