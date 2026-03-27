
locals {
  instances = { for k in flatten([
    for inx in range(var.vms) : {
      name : "${var.name}${format("%x", 10 + inx)}"
      image : var.template_id
      zone : var.zone
      type : var.type
      network_id : lookup(try(var.network["private"], {}), "ip4network", 0)
      ipv4 : lookup(try(var.network["private"], {}), "ip4subnet", "") != "" ? "${cidrhost(var.network["private"].ip4subnet, var.network["private"].ip4index + inx)}" : ""
      ipv6 : lookup(try(var.network["private"], {}), "ip6subnet", "") != "" ? "${cidrhost(var.network["private"].ip6subnet, var.network["private"].ip6index + inx)}" : ""
    }
  ]) : k.name => k }
}

output "instances" {
  value = local.instances
}

resource "scaleway_ipam_ip" "controlplane_v4" {
  for_each = local.instances

  address = each.value.ipv4
  source {
    private_network_id = each.value.network_id
  }

  tags = var.tags
}

resource "scaleway_ipam_ip" "controlplane_v6" {
  for_each = local.instances

  is_ipv6 = true
  address = each.value.ipv6
  source {
    private_network_id = each.value.network_id
  }

  tags = var.tags
}

resource "scaleway_instance_ip" "instances_v4" {
  for_each = lookup(try(var.network["public"], {}), "ip4", true) ? local.instances : {}
  zone     = each.value.zone
  type     = "routed_ipv4"
}

resource "scaleway_instance_ip" "instances_v6" {
  for_each = lookup(try(var.network["public"], {}), "ip6", true) ? local.instances : {}
  zone     = each.value.zone
  type     = "routed_ipv6"
}

resource "scaleway_instance_server" "instances" {
  for_each           = local.instances
  name               = each.value.name
  image              = each.value.image
  type               = each.value.type
  zone               = each.value.zone
  security_group_id  = var.firewall_id
  placement_group_id = var.placement_group_id
  tags               = var.tags

  enable_dynamic_ip = false
  ip_ids = compact([
    lookup(try(var.network["public"], {}), "ip4", true) ? scaleway_instance_ip.instances_v4[each.key].id : null,
    lookup(try(var.network["public"], {}), "ip6", true) ? scaleway_instance_ip.instances_v6[each.key].id : null
  ])

  user_data = {
    cloud-init = var.cloudinit_userdata
  }

  root_volume {
    volume_type = "sbs_volume"
    sbs_iops    = 5000
    size_in_gb  = var.boot_size
  }

  lifecycle {
    ignore_changes = [
      boot_type,
      type,
      image,
      root_volume,
      user_data,
      state,
      additional_volume_ids,
    ]
  }
}


resource "scaleway_instance_private_nic" "instances" {
  for_each = local.instances

  private_network_id = each.value.network_id
  server_id          = scaleway_instance_server.instances[each.key].id
  ipam_ip_ids        = [scaleway_ipam_ip.controlplane_v4[each.key].id, scaleway_ipam_ip.controlplane_v6[each.key].id]
}
