data "spectrocloud_registry" "common_registry" {
  name = "Public Repo"
}

data "spectrocloud_registry" "container_registry" {
  name = "vishwa-pack-registry"
}

data "spectrocloud_registry" "db_registry" {
  name = "svtest"
}

data "spectrocloud_registry" "bitnami_registry" {
  name = "Bitnami"

}

data "spectrocloud_pack_simple" "redis_pack" {
  type         = "operator-instance"
  name         = "redis-operator"
  version      = "6.2.12-1"
  registry_uid = data.spectrocloud_registry.common_registry.id
}

data "spectrocloud_pack_simple" "mysql_pack" {
  type         = "operator-instance"
  name         = "mysql-operator"
  version      = "0.6.2"
  registry_uid = data.spectrocloud_registry.db_registry.id
}

data "spectrocloud_pack_simple" "minio_pack" {
  type         = "operator-instance"
  name         = "minio-operator"
  version      = "4.5.4"
  registry_uid = data.spectrocloud_registry.db_registry.id
}

data "spectrocloud_pack_simple" "container_pack" {
  type         = "container"
  name         = "container"
  version      = "1.0.0"
  registry_uid = data.spectrocloud_registry.container_registry.id
}

data "spectrocloud_pack_simple" "kafka_pack" {
  type         = "helm"
  name         = "kafka"
  version      = "20.0.0"
  registry_uid = data.spectrocloud_registry.bitnami_registry.id
}

locals {
  registry_source_tier_params = {
    common_registry_uid = data.spectrocloud_registry.common_registry.id
    container_registry_uid = data.spectrocloud_registry.container_registry.id
    db_registry_uid = data.spectrocloud_registry.db_registry.id
    bitnami_registry_uid = data.spectrocloud_registry.bitnami_registry.id

    redis_source_uid = data.spectrocloud_pack_simple.redis_pack.id
    mysql_source_uid = data.spectrocloud_pack_simple.mysql_pack.id
    minio_source_uid = data.spectrocloud_pack_simple.minio_pack.id
    type_operator_instance = "operator-instance"

    container_source_id = data.spectrocloud_pack_simple.container_pack.id
    type_container = data.spectrocloud_pack_simple.container_pack.type

    kafka_source_id = data.spectrocloud_pack_simple.kafka_pack.id
    type_helm = data.spectrocloud_pack_simple.kafka_pack.type

    type_manifest = "manifest"

    base64_encode_password = base64encode("test123!wewe!")
  }
}

module "Spectro" {
  source = "../../"

  application_profiles = {
    for k in fileset("config/apps", "app-profile-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(templatefile("config/apps/${k}", local.registry_source_tier_params))
  }

}
