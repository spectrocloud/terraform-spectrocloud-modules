locals {




  cluster_map      = { for key, cluster in var.clusters : cluster.name => cluster }
  eks_keys         = compact([for i, cluster in local.cluster_map : cluster.cloudType == "eks" ? i : ""])
  eks_clusters     = [for key in local.eks_keys : lookup(local.cluster_map, key)]
  tke_keys         = compact([for i, cluster in local.cluster_map : cluster.cloudType == "tke" ? i : ""])
  tke_clusters     = [for key in local.tke_keys : lookup(local.cluster_map, key)]
  vsphere_keys     = compact([for i, cluster in local.cluster_map : cluster.cloudType == "vsphere" ? i : ""])
  vsphere_clusters = [for key in local.vsphere_keys : lookup(local.cluster_map, key)]

  libvirt_keys          = compact([for i, cluster in local.cluster_map : cluster.cloudType == "libvirt" ? i : ""])
  libvirt_clusters      = [for key in local.libvirt_keys : lookup(local.cluster_map, key)]
  edge_vsphere_keys     = compact([for i, cluster in local.cluster_map : cluster.cloudType == "edge-vsphere" ? i : ""])
  edge_vsphere_clusters = [for key in local.edge_vsphere_keys : lookup(local.cluster_map, key)]
  edge_keys             = compact([for i, cluster in local.cluster_map : cluster.cloudType == "edge" ? i : ""])
  edge_clusters         = [for key in local.edge_keys : lookup(local.cluster_map, key)]
  edge_native_keys             = compact([for i, cluster in local.cluster_map : cluster.cloudType == "edge-native" ? i : ""])
  edge_native_clusters         = [for key in local.edge_native_keys : lookup(local.cluster_map, key)]
  // all edge clusters (this is for appliance list)
  all_edge_clusters = setunion(local.libvirt_clusters)
}

data "spectrocloud_cluster" "clusters" {
  depends_on = [spectrocloud_cluster_tke.this, spectrocloud_cluster_edge_vsphere.this,
    spectrocloud_cluster_eks.this, spectrocloud_cluster_libvirt.this]
  for_each = local.cluster_map

  name = each.value.name
}

output "debug" {
  value = local.cluster_addon_deployments_map
}


