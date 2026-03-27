## Usage Example

```hcl
variable "instances" {
  default = {
    "fr-par-1" = {
      worker_count = 2,
    },
  }
}

locals {
  zones   = [for k, v in var.instances : k]
}

module "proxmox_nodegroup" {
  for_each = var.instances

  source = "github.com/sergelogvinov/terraform-scaleway-nodegroup"

  zone        = each.key
  vms         = lookup(try(var.instances[each.key], {}), "worker_count", 0)
  type        = "DEV1-S"
  name        = "worker"

  template_id = var.template_id

  # Size of the boot disk in GB
  boot_size      = 64

  network = {
    "public" = {
      ip6 = true
      ip4 = true
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | ~> 2.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | ~> 2.70.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [scaleway_instance_ip.instances_v4](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_ip) | resource |
| [scaleway_instance_ip.instances_v6](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_ip) | resource |
| [scaleway_instance_private_nic.instances](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_private_nic) | resource |
| [scaleway_instance_server.instances](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_server) | resource |
| [scaleway_ipam_ip.controlplane_v4](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/ipam_ip) | resource |
| [scaleway_ipam_ip.controlplane_v6](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/ipam_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_boot_size"></a> [boot\_size](#input\_boot\_size) | Size of the boot disk in GB | `number` | `32` | no |
| <a name="input_cloudinit_userdata"></a> [cloudinit\_userdata](#input\_cloudinit\_userdata) | Userdata for cloud-init image | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description | `string` | `""` | no |
| <a name="input_firewall_id"></a> [firewall\_id](#input\_firewall\_id) | ID of the firewall | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the VM | `string` | `"group-1"` | no |
| <a name="input_network"></a> [network](#input\_network) | n/a | `map(any)` | <pre>{<br/>  "public": {<br/>    "ip4": true,<br/>    "ip6": true<br/>  }<br/>}</pre> | no |
| <a name="input_placement_group_id"></a> [placement\_group\_id](#input\_placement\_group\_id) | ID of the placement group | `string` | `""` | no |
| <a name="input_pool"></a> [pool](#input\_pool) | Name of the VM pool | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the VM | `list(string)` | `[]` | no |
| <a name="input_template_id"></a> [template\_id](#input\_template\_id) | ID of the template VM | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Type for the VM | `string` | n/a | yes |
| <a name="input_vms"></a> [vms](#input\_vms) | Amount of VMs to create | `number` | `0` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Scaleway zone name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances"></a> [instances](#output\_instances) | n/a |
<!-- END_TF_DOCS -->