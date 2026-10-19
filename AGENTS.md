# Secure AI Fabric: agent entry point

Apply the reviewed ACI tenant/access composition through the retained NAC-ACI Terraform wrapper. See [README](README.md) for the human composition.

## Route the task

| Goal | Authoritative editable input | Procedure | Actual output | Relevant check | Next owner |
|---|---|---|---|---|---|
| Change tenant/access intent | Datacenter network/access inputs, then generated `data/` | [configuration](docs/CONFIGURATION.md) | selected tenant/access YAML | declared ownership and recursive scan closure | Datacenter |
| Prepare wrapper or existing-site import | `tf/`, `defaults/defaults.yml`, `modules/modules.yml` | [operations](agents/operations.md) | validated dedicated project root / import boundary | fmt, backend-disabled init, validate | site Terraform pipeline |
| Plan/apply selected changes | reviewed project root plus private APIC/backend inputs | [pipeline steps](agents/operations.md#owning-pipeline-planapply-steps) | private saved plan and observed effect | same-plan review; real APIC observation | fabric owner |

## Toolchain and execution boundary

Use Terraform >=1.3 with the committed lock file and NAC-ACI module 1.2.0. Module/provider acquisition and backend state are external dependencies; use approved caches and normal TLS. `examples/minimal/` is outside recursive deployment data. APIC credentials and `TF_HTTP_*` state access remain private. Formatting/validation are preparation; plan/apply run in the owning pipeline. Do not edit copied generated YAML to change platform intent.

Keep exact executable sequences in the linked procedure; update its input/output/check handoff when an interface changes. Record unknown runtime facts as unknown rather than inferring them from local success.
