name: ehl-core
description: ""
type: add-on
packs:
- name: bootstrap
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 1.0.0-7ff1498
  tag: 1.0.0-7ff1498
  values: |-
    pack:
      namespace: "ehl-control-plane"
      spectrocloud.com/install-priority: "10"
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all
            name: bootstrap
            version: 1.0.0-7ff1498
- name: clustermgr-service
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 1.0.0-f4a4859
  tag: 1.0.0-f4a4859
  values: |-
    pack:
      namespace: "ehl-control-plane"
      spectrocloud.com/install-priority: "20"
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all
            name: clustermgr-service
            version: 1.0.0-f4a4859
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/cluster-mgr/nginx_sidecar:1.0.0-f4a4859
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/cluster-mgr/cluster-mgr:1.0.0-f4a4859
- name: host-service
  type: helm
  layer: addon
  registry: helm-blr-ees
  version: 1.0.0-bcd39e0
  tag: 1.0.0-bcd39e0
  values: |-
    pack:
      namespace: "ehl-control-plane"
      spectrocloud.com/install-priority: "30"
      content:
        charts:
          - repo: https://blr-artifactory.cloud.health.ge.com/artifactory/helm-ees-all
            name: host-service
            version: 1.0.0-bcd39e0
        images:
          - image: blr-artifactory.cloud.health.ge.com/docker-eis-all/ehl-host-service/ehl-host-service:1.0.0-bcd39e0
cloudType: all