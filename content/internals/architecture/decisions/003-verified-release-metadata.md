# ADR 003: Verified release metadata

**Status:** Accepted

Release information crosses repository boundaries: product archives are produced by the application
repositories, widget packages are published from `widgets`, immutable package metadata lives in
`registry`, and installable formulas and casks live in `homebrew-tap`.

Every consumer must identify one immutable producer artifact by its versioned tag, asset name, and
checksum. Consumers may retain their own release cadence, but must validate that those values agree
before publishing a change. Repository-local checks enforce mechanical invariants; release automation
remains responsible for verifying that the referenced artifact exists and has the recorded checksum.
