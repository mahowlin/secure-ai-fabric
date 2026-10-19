# Prepare the retained NAC-ACI adapter

Start at [the file ownership map](../docs/CONFIGURATION.md). Use the site's approved Terraform toolchain and provider/module cache. Commands are from this checkout root; they validate configuration without APIC calls. Initialization may acquire declared dependencies and state settings, so this local preparation disables backend initialization and preserves the lock file.

```bash
terraform -chdir=tf fmt -check
terraform -chdir=tf init -backend=false -lockfile=readonly
terraform -chdir=tf validate
```

The pinned NAC-ACI module is external, not vendored. If dependency acquisition is unavailable, use the approved cache; do not replace pins or copy another installed cache into source. Validation is not a live plan.

For an actual plan/apply, use the site's owning pipeline with its private APIC URL/user/password, normal trusted CA and HTTP backend variables. `TF_VAR_apic_password` is a runtime reference. Do not commit state, saved plan, backend credentials or provider caches. The wrapper's recursive data scan and input conflicts must be reviewed before plan. This guide contains no generic local apply command because execution belongs to that pipeline.

## Owning pipeline plan/apply steps

The repository provides Terraform execution, not a newly provisioned CI runner or state service. An existing site pipeline supplies backend/provider/auth/trust and runs these steps after import verification. `FABRIC_SCAN_ROOT` is the dedicated project root verified by the Datacenter handoff (data/modules/defaults). `PRIVATE_PLAN` must be an absolute private path on that runner; saved plans can contain sensitive values.

```bash
: "${PRIVATE_PLAN:?Set absolute private saved-plan path}"
: "${FABRIC_SCAN_ROOT:?Set the exact verified staged project root}"
terraform -chdir=tf init -lockfile=readonly
terraform -chdir=tf plan -var="project_dir=$FABRIC_SCAN_ROOT" -out="$PRIVATE_PLAN"
# The site's existing plan review precedes applying that same saved plan.
terraform -chdir=tf apply "$PRIVATE_PLAN"
```

These are live site pipeline steps. They are not part of local documentation validation and are not executed by rendering/importing YAML.
