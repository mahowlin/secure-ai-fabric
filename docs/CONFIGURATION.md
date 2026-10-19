# ACI configuration layout

This repository preserves the NAC-ACI tenant/access structure: tenant files describe logical policy and routing; access files describe how switches attach that policy to interfaces and domains. The selected generated example is a redacted role-based composition, not an APIC inventory.

| File | Contribution |
|---|---|
| [data/platform-management/platform-management.yml](../data/platform-management/platform-management.yml) | Management VRF, management bridge domain/EPG, gateway subnet and server static ports |
| [data/access/10-platform-management-domains.yml](../data/access/10-platform-management-domains.yml) | Management VLAN pool, physical domain and AAEP |
| [data/access/30-platform-management-attachments.yml](../data/access/30-platform-management-attachments.yml) | Management and tenant uplink port/switch/interface selectors and policy groups |
| [data/tenant-workloads/tenant-workloads.yml](../data/tenant-workloads/tenant-workloads.yml) | Workload tenant VRF, management-service and guest-worker SVI/BGP interfaces, route policy and contracts |
| [data/tenant-workloads/access-policies.yml](../data/tenant-workloads/access-policies.yml) | Tenant VLAN pools, physical/routed domains and shared AAEP bindings |

## What to customize

Change catalog allocations and `aciAttachment` in [Secure AI Datacenter](https://github.com/mahowlin/secure-ai-datacenter/blob/main/docs/architectures/FABRIC_NETWORK.md), then render and import. Cluster node NIC/bond/BGP configuration is generated for Compute/GitOps from the same inputs. Changing only an ACI VLAN or address here breaks that join.

Management access and tenant peering remain separate. The management bridge domain uses the selected existing site L3Out/contract. Tenant routing advertises/reaches selected cluster Service addresses and worker networks using its own SVI/peer configuration. Existing upstream routing and fabric commissioning are site dependencies; no particular OSPF design is assumed.

## Import into an existing ACI automation repository

The contract is `apic` NAC YAML, not this wrapper's folder names. Import the selected tenant files and shared access files into your normal recursive scan, preserving cross-file names and resolving overlap with existing domains/AAEPs/interface profiles. Do not scan both a copied import and another independently maintained definition of the same object.

This wrapper scans **all `data/**/*.yml`**, plus `modules/*.yml` and `defaults/*.yml`. Numbered access filenames improve navigation; they are not an apply-order mechanism. The minimal [standalone example](../examples/minimal/tenant.yml) is outside this scan and should not be mixed with the selected composition.

`defaults/defaults.yml` and `modules/modules.yml` retain execution categories. Management access and tenants are enabled; fabric/pod/node-wide policy remains outside the selected wrapper. Provider/module versions and backend mechanics remain in `tf/`. See [exact preparation](../agents/operations.md) for validation, private state/credentials and live execution boundaries.

## Generated import isolation

The [Datacenter handoff](https://github.com/mahowlin/secure-ai-datacenter/blob/main/agents/fabric.md#dedicated-generated-scan-root) prepares a fresh project scan root and rejects every extra generated file. The owning pipeline must plan that exact `project_dir`. Overlaying a renamed tenant onto an old `data/` tree would retain stale objects in the recursive scan. Existing NAC projects instead use their reviewed object/import ownership; isolated slice verification does not authorize deleting other owners' data or certify the complete merged configuration.
