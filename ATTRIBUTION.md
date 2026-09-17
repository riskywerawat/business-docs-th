# Attribution

## diagram-design (vendored under `assets/diagram-design/`)

- Upstream: https://github.com/cathrynlavery/diagram-design
- License: MIT — Copyright (c) 2025 Cathryn Lavery
- Vendored copy: `assets/diagram-design/` (see `LICENSE.upstream` for the full MIT text)
- Vendored at upstream commit `8d8b2993ee2256ee7dfc0eeb3b5713aba3b60792` (2026-09-10)
- Declared locally in `assets/diagram-design/UPSTREAM_COMMIT`

Verify the copy still matches the pin (offline, then against upstream):

```bash
./scripts/fetch-diagram-design.sh --verify           # local marker must equal PIN
./scripts/fetch-diagram-design.sh --verify-upstream  # diff against real upstream (network)
```

`PIN` lives in two places that must stay in sync: `scripts/fetch-diagram-design.sh`
and this file. `--update` re-vendors exactly `PIN`; `--update-latest` is the only
way to move it and refuses to hide the bump — `--verify` fails until both are updated.

Files copied from diagram-design into generated docs MUST keep the
`Source: cathrynlavery/diagram-design (MIT)` comment in the file header
(`--copy` writes it automatically). See
`assets/diagram-design/THIRD_PARTY_LICENSES.md` for icon/font provenance
(Tabler Icons MIT, Simple Icons CC0, log-z/logos MIT, Devicon MIT).
