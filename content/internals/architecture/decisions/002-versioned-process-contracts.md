# ADR 002: Versioned process contracts

**Status:** Accepted

Cross-process values and protocols are owned by the `EasyBarShared` target. That includes resolved
runtime configuration, environment keys, socket resolution, typed requests and responses, and the
internal IPC protocol version.

The contract is intentionally public to EasyBar-owned executables while remaining an internal product
boundary, not a third-party stability promise. A compatible change may add an optional field or command.
A breaking wire or semantic change must increment the IPC protocol version and update both sides of the
boundary in the same release.

Frontend repositories consume these contracts rather than recreating their own configuration or socket
parsers. Their tests should assert the frontend profile and the shared contract values they rely on.
