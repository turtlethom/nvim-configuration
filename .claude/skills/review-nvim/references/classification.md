# Classification, evidence, and versions

Read this when a classification isn't obvious, before using POORLY DESIGNED, or when a claim depends on a version.

## Decision procedure

Ask in order; the first "yes" is the classification.

1. **Does it fail, error, or silently not do what the code clearly intends — in the user's Neovim and plugin versions?** → BROKEN
   - Includes: nonexistent or removed API; wrong function signature; option name the plugin doesn't read; settings silently dropped (e.g. lazy.nvim `opts` ignored because a custom `config` never calls `setup(opts)`); plugin can't load; mapping bound to the wrong key; Lua truthiness bugs (`if vim.fn.has(...) then` is always true).
   - "Silently ignored" counts as BROKEN only if the ignored setting would change behavior. An ignored setting equal to the default has no effect → POORLY DESIGNED (misleading dead config), priority 4.
2. **Is it officially deprecated or obsolete?** → DEPRECATED
   - Requires a source: `:h deprecated`, a deprecation warning at runtime, release notes / `:h news`, or the plugin's own changelog/README/deprecation notice.
   - Not deprecated: something with a newer alternative that isn't marked deprecated. `vim.api.nvim_set_keymap`, `vim.cmd`, `vim.opt` vs `vim.o`, `on_attach` vs an `LspAttach` autocmd — all supported.
   - An archived/unmaintained *plugin* is not deprecated *code*. Mention it only if it causes an actual failure, or the user asks. Never propose replacing a working plugin as part of a fix.
   - Using packer.nvim itself (archived 2023) is not something to fix in a normal review — migrating managers is out of scope. Packer-era *patterns* that don't work under the user's actual manager (e.g. `requires`, `run` in a lazy.nvim spec) are BROKEN.
3. **Is there a concrete, nameable engineering cost?** → POORLY DESIGNED
   - You must be able to finish: "This will cause ___ when ___." Examples:
     - Autocmd without a cleared augroup → duplicated handlers every time the file is re-sourced.
     - Same `on_attach`/capabilities block copied across N servers → fixes applied to one silently diverge from the others.
     - Top-level `require("plugin")` in a spec file → plugin loaded at startup despite lazy-loading triggers (measurable via `:Lazy profile` / `nvim --startuptime`).
     - Hidden ordering dependency (module B only works because A happened to be required first).
     - `pcall(require, ...)` that swallows errors with no fallback → failures become invisible.
   - Priority 3 if the cost is significant (reliability, real startup cost, divergence-prone duplication, unclear module boundaries that keep causing bugs). Priority 4 if minor (small duplication, dead config, mild readability).
   - Performance claims need a plausible measurable effect, not "eager loading is bad." One small plugin loaded at startup is not a design defect.
4. **Otherwise** → STYLE / PREFERENCE. Not presented unless the user asked about style or idiom, or it causes a real readability/consistency problem (then priority 4, still labeled STYLE / PREFERENCE).

## Precedence

BROKEN > DEPRECATED > POORLY DESIGNED > STYLE / PREFERENCE. When several apply, use the most severe one that is actually true, and explain the issue in terms of that consequence. Example: `vim.lsp.buf.formatting()` is a deprecated name *and* removed in modern Neovim → BROKEN (it errors), and the fix is the replacement call.

## Evidence language

Keep these four kinds of statement visibly distinct in the response:

| Kind | Phrase it as |
|---|---|
| Factual API behavior | "`vim.fn.has()` returns 0 or 1; in Lua, 0 is truthy." |
| Deprecation | "Deprecated in Neovim 0.10 (`:h deprecated`); replacement is …" |
| Engineering recommendation | "Recommended because …" — always with the concrete cost. |
| Preference | "This is a matter of taste: …" — only when style is in scope. |

Confidence:
- **Verified** — you read the installed docs/source or ran a check. State it plainly.
- **Known, not verified here** — well-established behavior. State it, name where the user can confirm.
- **Uncertain** — say so, say what would confirm it, and don't let an uncertain claim carry a BROKEN or DEPRECATED label on its own.

## Versions

- A deprecation applies only if the user's version is at or past it. If they're on an older version, the "replacement" may not exist — recommending it would break their config.
- If they're on a version where something was *removed*, it's BROKEN, not DEPRECATED.
- When versions are unknown and the claim depends on them: state the assumption in the response's first line, and either phrase conditionally or give the one command that settles it (`nvim --version`, `git -C <plugin dir> log -1`, look up the plugin in `lazy-lock.json`).
- Plugin branches matter as much as versions (nvim-treesitter `master` vs `main` have incompatible APIs). Check `lazy-lock.json` for `branch`.
- The deprecation tables in the other references cover what was known at writing time. For newer releases, check the installed `:h deprecated` and `:h news` rather than assuming the tables are complete.

## Behavior change

- **No** only if the change is behavior-identical for the user's setup: same mappings, same options, same load result.
- **Yes** whenever anything observable differs, including: a bug fix that makes intended behavior start happening; a different load time for a plugin (lazy-loading changes *when* commands/mappings exist); a changed default; a replacement API with slightly different semantics (e.g. `vim.diagnostic.jump` vs `goto_next` float behavior). Say exactly what differs.
- If a lazy-loading change could make a command or mapping unavailable until a trigger fires, that's a behavior change.
