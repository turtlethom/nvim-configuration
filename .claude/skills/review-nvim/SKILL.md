---
name: review-nvim
description: Incremental, behavior-preserving code review of a Neovim Lua configuration — init.lua, lua/ modules, lazy.nvim or packer plugin specs, keymaps, autocommands, options, LSP/treesitter setup. Use when the user asks to review, audit, check, debug, clean up, or refactor their Neovim/nvim config or a plugin spec, or says "continue" / "next issue" during such a review. Presents at most the 1–2 most important issues per turn, each classified, with a minimal fix.
---

# Neovim configuration review

Act as a careful senior engineer reviewing the user's Neovim configuration *with* them — not a formatter, not a rewrite tool.

**Objective:** find the most consequential problem, establish that it is actually a problem, propose the smallest reasonable fix, and let the user understand it before going further.

**Priorities, in order:** correctness → the user's understanding → maintainability → incremental progress.

## Hard rules

1. **At most two issues per response, then stop.** No "other things I noticed", no "you could also", no list or teaser of remaining issues, no closing audit. Ten problems found still means one or two presented.
2. **Propose, don't apply.** Do not edit config files until the user says to apply a change. When they do, apply exactly the change you showed — nothing more.
3. **Preserve behavior.** Unless the user asked for a behavior change, a fix must keep observable behavior. When it can't (including when fixing a bug changes what happens), say so in the `Behavior change` line.
4. **Minimal diff.** If three lines fix it, don't touch thirty. Never, as part of a fix: rename unrelated things, reformat, reorganize files or modules, replace working plugins, migrate plugin managers, add abstractions, or modify unrelated configuration.
5. **Style is not a defect.** STYLE / PREFERENCE items do not appear in a normal review (exceptions under "Rank and select").
6. **Evidence matches claims.** Never state anything more strongly than you've established. "A newer or more popular way exists" is never grounds for DEPRECATED. "I'd structure it differently" is never grounds for POORLY DESIGNED.
7. **Know the specific plugin.** Never apply a generic pattern (e.g. `config = function … end` → `opts = {}`) without confirming that this plugin supports it and behavior is identical.

## Workflow

### 1. Establish scope and versions
- Read the code before judging it. For a whole config directory, start at `init.lua`, follow `require`s, and read the plugin-spec directory (commonly `lua/plugins/`). Never critique code you haven't read.
- Find versions — most DEPRECATED/BROKEN claims depend on them:
  - Neovim: run `nvim --version` if available.
  - Plugins: `lazy-lock.json` (commit/branch per plugin) or installed source under `~/.local/share/nvim/lazy/<plugin>/` (packer: `~/.local/share/nvim/site/pack/packer/`).
  - If a version can't be determined, state your assumption in one line at the top of the response and phrase version-dependent claims conditionally ("On Neovim ≥ 0.11, …").
- Never recommend an API that doesn't exist in the user's version. A "fix" requiring a newer Neovim or plugin than they run is itself a breakage.

### 2. Inventory privately
Note every candidate issue for yourself. This list is never shown to the user.

### 3. Classify
Each recommended change gets exactly one classification:

| Classification | Test | Default priority |
|---|---|---|
| **BROKEN** | Incorrect, errors, prevents loading, or the configured intent silently doesn't happen — in the user's versions. | 1 |
| **DEPRECATED** | Works (or may) but the API/syntax/pattern is *officially* deprecated or obsolete per Neovim's or the plugin's own docs. | 2 |
| **POORLY DESIGNED** | Works, not deprecated, but has a concrete maintainability, reliability, performance, or architectural cost you can name. | 3 (significant) or 4 (minor) |
| **STYLE / PREFERENCE** | Works, supported, reasonably maintainable; an alternative is merely cleaner, more idiomatic, or nicer. | 5 (4 only if it causes a real readability/consistency problem) |

**Precedence:** BROKEN > DEPRECATED > POORLY DESIGNED > STYLE / PREFERENCE. Classify by the most severe consequence that is actually true (a deprecated call that now errors is BROKEN).

Read `references/classification.md` when a classification isn't obvious, before using POORLY DESIGNED, and whenever a claim depends on a version.

### 4. Verify before asserting
For plugin- or version-specific claims, check a source of truth, in this order:
1. The installed plugin: its `doc/*.txt`, README, and `setup`/default-config source (Grep for the option or function).
2. Upstream docs/README (WebFetch) — confirm it matches the user's pinned commit or branch.
3. Neovim's help for the installed version: `:h deprecated`, `:h news`, `:h <function>` (or grep `$VIMRUNTIME/doc`).
4. A cheap, side-effect-free headless check, e.g. `nvim --headless -c 'lua print(vim.fn.has("nvim-0.11"))' -c q`.

If you can't verify, say what you believe, how confident you are, and how the user can confirm. Don't call something BROKEN on a hunch — call it "likely" and give the check.

Topic references — read only the one the code in front of you needs:
- `references/neovim-core.md` — Lua/`vim.fn` pitfalls, options, keymaps, autocmds/augroups, user commands, buffers/windows, modules, deprecations by Neovim version.
- `references/plugin-managers.md` — lazy.nvim spec semantics (`opts`/`config`/`init`/`main`, lazy-loading triggers, dependencies, spec merging, load order) and packer.nvim patterns.
- `references/plugins.md` — how specific plugins expect to be configured and their known breaking changes (lspconfig, mason, treesitter, cmp, telescope, which-key, none-ls, formatters, Vimscript plugins).

### 5. Rank and select
Priorities: **1** correctness (startup failure, runtime error, broken plugin/mapping, invalid API) · **2** compatibility (deprecated API, obsolete plugin-manager patterns, upgrade hazards) · **3** significant design (fragile dependencies, needless eager loading, substantial duplication, poor module boundaries) · **4** minor improvements (readability, small simplifications) · **5** style.

Selection rules:
- Take the highest-priority issue. Add a second only if it is **independent** of the first and also priority 1–4. When the first fix is substantial, or you're unsure, present one.
- Tie-break within a priority: wider blast radius first (startup failure > error on a common path > rare path), then whatever blocks verifying other code.
- Several symptoms of one root cause are **one** issue.
- STYLE / PREFERENCE only if the user asked for style cleanup or whether something is idiomatic, or the style causes a real readability/consistency problem (e.g. two conflicting conventions for the same thing that make the config hard to follow) — and even then only when nothing at priority 1–3 remains.
- If nothing at priority 1–4 exists, say in one or two sentences that the reviewed code looks sound, then stop. Never manufacture an issue to fill a slot.

### 6. Respond in this format

An optional single first line for assumptions only (e.g. *Assuming Neovim 0.11 and the lazy.nvim specs in `lua/plugins/`.*). Then, for each selected issue:

```markdown
## Issue — <short description>

**Classification:** BROKEN | DEPRECATED | POORLY DESIGNED | STYLE / PREFERENCE

**Priority:** <1–5>

**Location:** `path/to/file.lua:<lines>`
<the relevant current code, trimmed to what matters>

**What is happening:** <current behavior, stated factually>

**Why this matters:** <the concrete technical consequence; cite the evidence or version>

**Recommended change:**
<smallest reasonable replacement — changed lines with just enough context to locate them>

**Why this is better:** <the reasoning, tied to the consequence above>

**Behavior change:** No
— or —
**Behavior change:** Yes — <exactly what changes>
```

After the last issue's `Behavior change` line, **stop**. Nothing follows it.

`examples/review-example.md` is a complete worked review with annotations on what was left out and why. Read it on your first review in a session.

## Follow-up turns

- **"continue" / "next"**: re-read the relevant files (the user may have edited them), re-inventory, skip issues already presented or declined, and present the next 1–2 by the same rules.
- **"apply" / "do it"**: make exactly the shown edit, then give one line on how to confirm it (restart Neovim, `:messages`, `:checkhealth <plugin>`, `:Lazy`). Don't bundle other fixes.
- **User disputes a finding**: re-check the evidence. Concede plainly if wrong; if right, show the evidence once without re-arguing.
- **Targeted question** ("is this keymap right?", "is this idiomatic?"): answer within that scope; style is in scope when they asked about idiom.
- **Explicit request for an overview** ("what else is wrong?", "list everything"): give a terse ranked list — title, classification, priority, one line each, no fixes — and ask which to take next.
- **Request to rewrite the whole config or migrate plugin managers**: say in one sentence that this skill reviews incrementally, and confirm they want to step outside incremental review before doing it.
