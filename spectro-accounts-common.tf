locals {

  account_map      = { for i, account in var.accounts : tostring(i) => account }
  account_eks_keys = compact([for i, account in local.account_map : account.cloudType == "eks" ? i : ""])
  eks_accounts     = [for key in local.account_eks_keys : lookup(local.account_map, key)]
  account_tke_keys = compact([for i, account in local.account_map : account.cloudType == "tencent" ? i : ""])
  tke_accounts     = [for key in local.account_tke_keys : lookup(local.account_map, key)]
  account_vsphere_keys = compact([for i, account in local.account_map : account.cloudType == "vsphere" ? i : ""])
  vsphere_accounts     = [for key in local.account_vsphere_keys : lookup(local.account_map, key)]
}