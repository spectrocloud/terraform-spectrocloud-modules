locals {

  /*
  infra-pack-params-replaced is a map of key (<cluster_name>-<cluster_profile_name>-<pack_name>) and
  replaced value with given parameters in input cluster parameter.

  Input:

    infra: //code snippet from yaml file
      name: EKS-Base-CP-with-percentage
      packs:
        - name: sapp-hipster
          version: "2.0.0"
          override_type: params #[values, params, template]
          params:
            HIPSTER_NAMESPACE: "hipster-cluster"

  Eg:
  {
    "eks-dev-cluster-EKS-Base-CP-sapp-hipster" = <<-EOT
      pack:
        spectrocloud.com/install-priority: "10"
      manifests:
        hipster:
          # Liveness probe default itmeout
          timeout: 60

          # Disable Tracing
          disableTracing: true

          # The namespace to create the app in
          namespace: "hipster-cluster"
      EOT
  }
  */

  // local.cluster_infra_profiles_map should contain information provided by user in cluster.yaml file
  infra-pack-params-replaced = { for v in flatten([
    for k, v in local.cluster_infra_profiles_map : [
      for p in try(v.packs, []) : {
        name = format("%s%%%s-%s-%s", k, v.name, try(v.version, "1.0.0"), p.name)
        value = join("\n", [
          for line in split("\n", try(p.is_manifest_pack, false) ?
            element([for x in local.cluster-profile-pack-map[format("%s%%%s-%s", v.name, try(v.version, "1.0.0"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
          local.cluster-profile-pack-map[format("%s%%%s-%s", v.name, try(v.version, "1.0.0"), p.name)].values) :
          format(
            replace(line, "/%(${join("|", keys(p.params))})%/", "%s"),
            [
              for value in flatten(regexall("%(${join("|", keys(p.params))})%", line)) :
              lookup(p.params, value)
            ]...
          )
        ])
      } if p.override_type == "params"
    ]]) : v.name => v.value
  }


  /*
  infra-pack-template-params-replaced is a map of key (<cluster_name>-<cluster_profile_name>-<pack_name>) and
  replaced value with given map of parameters in input cluster parameter. Template will come from cluster profile pack
  and template would be iterated as many times as it present in param map

    Input:

    infra: //code snippet from yaml file
      name: EKS-Base-CP-with-percentage
      packs:
        - name: profile-installation
          is_manifest_pack: true
          manifest_name: profile-install-crd
          override_type: template
          params:
            - NAMESPACE_NAME: namespace-cluster-1
              NAMESPACE_LABEL_KEY: app
              NAMESPACE_LABEL_VALUE: cluster1
            - NAMESPACE_NAME: namespace-cluster-2
              NAMESPACE_LABEL_KEY: app
              NAMESPACE_LABEL_VALUE: cluster2

      Manifest content in manifest pack:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: "%NAMESPACE_NAME%"
        labels:
          "%NAMESPACE_LABEL_KEY%": "%NAMESPACE_LABEL_VALUE%"
      ---

      Value after replacement:

      apiVersion: v1
      kind: Namespace
      metadata:
        name: "namespace-cluster-1"
        labels:
          "app": "cluster1"
      ---

      apiVersion: v1
      kind: Namespace
      metadata:
        name: "namespace-cluster-2"
        labels:
          "app": "cluster2"
      ---
  */
  infra-pack-template-params-replaced = { for v in flatten([
    for k, v in local.cluster_infra_profiles_map : [
      for p in try(v.packs, []) : {
        name = format("%s-%s-%s", k, v.name, p.name)
        value = join("\n", flatten([for l in p.params : [
          join("\n", [
            for line in split("\n", try(p.is_manifest_pack, false) ?
              element([for x in local.cluster-profile-pack-map[format("%s%%%s-%s", v.name, try(v.version, "1.0.0"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
            local.cluster-profile-pack-map[format("%s%%%s-%s", v.name, try(v.version, "1.0.0"), p.name)].values) :
            format(
              replace(line, "/%(${join("|", keys(l))})%/", "%s"),
              [
                for value in flatten(regexall("%(${join("|", keys(l))})%", line)) :
                lookup(l, value)
              ]...
            )
          ])
        ]]))
      } if p.override_type == "template"
    ]]) : v.name => v.value
  }

  addon_pack_params_replaced = { for v in flatten([
    for k, v in local.cluster_addon_profiles_map : [
      for e in v : [
        for p in try(e.packs, []) : {
          name = format("%s%%%s-%s-%s", k, e.name, try(e.version, "1.0.0"), p.name)
          value = join("\n", [
            for line in split("\n", try(p.is_manifest_pack, false) ?
              element([for x in local.cluster-profile-pack-map[format("%s%%%s-%s", e.name, try(e.version, "1.0.0"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
            local.cluster-profile-pack-map[format("%s%%%s-%s", e.name, try(e.version, "1.0.0"), p.name)].values) :
            format(
              replace(line, "/%(${join("|", keys(p.params))})%/", "%s"),
              [
                for value in flatten(regexall("%(${join("|", keys(p.params))})%", line)) :
                lookup(p.params, value)
              ]...
            )
          ])
        } if p.override_type == "params"
      ]
    ]]) : v.name => v.value
  }

  addon_pack_template_params_replaced = { for v in flatten([
    for k, v in local.cluster_addon_profiles_map : [
      for e in v : [
        for p in try(e.packs, []) : {
          name = format("%s-%s-%s", k, e.name, p.name)
          value = join("\n", flatten([for l in p.params : [
            join("\n", [
              for line in split("\n", try(p.is_manifest_pack, false) ?
                element([for x in local.cluster-profile-pack-map[format("%s%%%s-%s", e.name, try(e.version, "1.0.0"), p.name)].manifest : x.content if x.name == p.manifest_name], 0) :
              local.cluster-profile-pack-map[format("%s%%%s-%s", e.name, try(e.version, "1.0.0"), p.name)].values) :
              format(
                replace(line, "/%(${join("|", keys(l))})%/", "%s"),
                [
                  for value in flatten(regexall("%(${join("|", keys(l))})%", line)) :
                  lookup(l, value)
                ]...
              )
            ])
          ]]))
      } if p.override_type == "template"]
    ]
    ]) : v.name => v.value
  }

  infra_pack_manifests = { for v in flatten([
    for k, v in local.cluster_infra_profiles_map : [
      for p in try(v.packs, []) : {
        name = format("%s-%s-%s", k, v.name, p.name)
        value = {
          identifier = format("%s-%s-%s-%s", k, v.name, p.name, p.manifest_name)
          name       = p.manifest_name
          content = lookup(local.infra-pack-params-replaced, format("%s-%s-%s", k, v.name, p.name),
            lookup(local.infra-pack-template-params-replaced, format("%s-%s-%s", k, v.name, p.name), "")
          )
        }
      } if try(p.is_manifest_pack, false)
    ]
    ]) : v.name => v.value
  }

  addon_pack_manifests = { for v in flatten([
    for k, v in local.cluster_addon_profiles_map : [
      for e in v : [
        for p in try(e.packs, []) : {
          name = format("%s-%s-%s", k, e.name, p.name)
          value = [{
            identifier = format("%s-%s-%s-%s", k, e.name, p.name, p.manifest_name)
            name       = p.manifest_name
            content = lookup(local.addon_pack_params_replaced, format("%s-%s-%s", k, e.name, p.name),
              lookup(local.addon_pack_template_params_replaced, format("%s-%s-%s", k, e.name, p.name), "")
            )
          }]
      } if try(p.is_manifest_pack, false)]
    ]
    ]) : v.name => v.value
  }


  cluster_map  = { for i, cluster in var.clusters : tostring(i) => cluster }
  eks_keys     = compact([for i, cluster in local.cluster_map : cluster.cloudType == "eks" ? i : ""])
  eks_clusters = [for key in local.eks_keys : lookup(local.cluster_map, key)]
  tke_keys     = compact([for i, cluster in local.cluster_map : cluster.cloudType == "tke" ? i : ""])
  tke_clusters = [for key in local.tke_keys : lookup(local.cluster_map, key)]

  libvirt_keys          = compact([for i, cluster in local.cluster_map : cluster.cloudType == "libvirt" ? i : ""])
  libvirt_clusters      = [for key in local.libvirt_keys : lookup(local.cluster_map, key)]
  edge_vsphere_keys     = compact([for i, cluster in local.cluster_map : cluster.cloudType == "edge-vsphere" ? i : ""])
  edge_vsphere_clusters = [for key in local.edge_vsphere_keys : lookup(local.cluster_map, key)]
  edge_keys             = compact([for i, cluster in local.cluster_map : cluster.cloudType == "edge" ? i : ""])
  edge_clusters         = [for key in local.edge_keys : lookup(local.cluster_map, key)]
  // all edge clusters (this is for appliance list)
  all_edge_clusters = setunion(local.libvirt_clusters)

  // all edge clusters with system profiles (this is for system profile list)
  all_system_profile_clusters = setunion(local.libvirt_clusters, local.edge_vsphere_clusters, local.edge_clusters)

}