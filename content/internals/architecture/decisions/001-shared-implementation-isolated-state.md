# ADR 001: Shared implementation, isolated frontend state

**Status:** Accepted

EasyBar and EasyBar Native share implementation through `easybar-kit`, but they are distinct
products. Each frontend owns its application identity, presentation policy, config path, runtime
directory, package state, logs, control socket, and command name.

Shared behavior belongs in a narrow EasyBarKit target. A frontend may supply defaults or presentation
policy, but must not copy Lua parsing, package validation, rendering, IPC, or helper-process logic.

This preserves one implementation of portable widget behavior while preventing a package update,
reload, or configuration change in one frontend from mutating the other frontend's state.
