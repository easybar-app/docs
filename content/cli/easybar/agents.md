# Helper agents

The `easybar agent` commands inspect or restart the calendar and network helper agents installed with
EasyBar.

## Restart agents

```bash
easybar agent restart calendar
easybar agent restart network
easybar agent restart all
```

A single-agent command accepts `--socket PATH`. The combined command uses both configured agent
sockets and reports partial failures.

## Inspect versions

```bash
easybar agent version calendar
easybar agent version network
easybar agent version all
easybar agent version all --json
```

Version commands query the running processes. They report application and protocol versions and mark
differences from the EasyBar CLI as mismatches.

Use `easybar agent --help`, `easybar agent restart --help`, or `easybar agent version --help` for the
complete option reference. See [Agent diagnostics](../../products/easybar/runtime/agent-diagnostics.md)
for service and socket troubleshooting.
