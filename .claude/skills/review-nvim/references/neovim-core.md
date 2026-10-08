# Neovim core: pitfalls and deprecations

Read the section relevant to the code under review. Verify version-specific entries against the user's installed `:h deprecated` / `:h news`.

## Lua ↔ Vimscript truthiness (common BROKEN)

- `vim.fn.has()`, `vim.fn.exists()`, `vim.fn.executable()`, `vim.fn.isdirectory()`, `vim.fn.filereadable()` return **numbers**. `0` is truthy in Lua.
  - `if vim.fn.has("win32") then` → always true. Fix: `if vim.fn.has("win32") == 1 then`.
  - `vim.fn.empty()` likewise returns 0/1.
- `vim.opt.<name>` returns an **Option object**, not the value. `if vim.opt.number then` is always true; `vim.opt.shiftwidth + 1` errors. Read with `vim.o.number` / `vim.bo` / `vim.wo`, or `vim.opt.number:get()`.
- `vim.g.foo` reading an unset variable gives `nil`; Vimscript-set booleans are `0`/`1`, not `false`/`true`.

## Options

- `vim.o` = `:set` (global + current local), `vim.go` = global only, `vim.bo`/`vim.wo` = buffer/window-local of the *current* buffer/window.
- Setting window-local options with `vim.wo` in init affects only the current window; later windows inherit from the current window at split time — usually fine at startup, wrong inside autocmds targeting other windows.
- `vim.opt` list/map options support `:append()`, `:prepend()`, `:remove()`. Plain assignment of a string to `vim.opt.shortmess` *replaces* the whole value (behavior change risk when "simplifying").
- `vim.opt` vs `vim.o` choice is STYLE.

## Keymaps

- `vim.keymap.set(mode, lhs, rhs, opts)`: non-recursive by default (`remap = false`); `rhs` may be a string or Lua function; `opts.buffer` makes it buffer-local. Passing `noremap = true` is redundant but harmless (STYLE).
- `vim.api.nvim_set_keymap` is **not** deprecated; `rhs` must be a string (use `opts.callback` for functions). Recursive by default unless `noremap = true`.
- `<leader>` is expanded **when the mapping is created**. `vim.g.mapleader` must be set before any leader mapping is defined, including those lazy.nvim creates from `keys` specs during `require("lazy").setup()`. Setting it later → mappings bound to `\` (BROKEN).
- `rhs = require("x").fn` evaluates `require` at definition time (eager load; errors if the module isn't available yet). Wrap: `function() require("x").fn() end`.
- Mode string vs table: `"n"`, `{ "n", "v" }`. `"v"` covers visual+select; `"x"` is visual only.
- Same lhs mapped twice in the same mode/scope: the last one wins silently — BROKEN if both are intended.

## Autocommands and augroups

- `nvim_create_autocmd` without a `group` (or with a group not created with `{ clear = true }`) → handlers duplicate every time the file is re-sourced. POORLY DESIGNED (P3) normally; BROKEN if the duplication causes visible misbehavior (e.g. double formatting, repeated notifications).
- `nvim_create_augroup(name, { clear = true })` is the default; `clear = true` is the default value of the option.
- A Lua `callback` that **returns a truthy value deletes the autocmd**. `callback = function() return vim.fn.something() end` can silently unregister itself after first run (BROKEN). Fix: don't return the value.
- `pattern` and `buffer` are mutually exclusive; `command` and `callback` are mutually exclusive.
- `pattern` for `FileType` matches filetype names, not file globs (`pattern = "*.py"` on `FileType` never matches; use `"python"`).
- Callbacks receive `args` (`args.buf`, `args.match`, `args.data`) — prefer `args.buf` over `0` when the event may fire for a non-current buffer.
- `vim.cmd("autocmd ...")` without `augroup ... | autocmd! | augroup END` has the same duplication issue.

## User commands

- `nvim_create_user_command(name, fn_or_string, opts)`: name must start with an uppercase letter (BROKEN otherwise). `opts.nargs`, `opts.range`, `opts.bang`, `opts.complete`. Function receives one table (`args.args`, `args.fargs`, `args.bang`, `args.line1/line2`).
- Defining with the same name again requires `force = true` (default true for this API).

## Buffers and windows

- Handle `0` means current. Stored buffer/window handles can become invalid — check `nvim_buf_is_valid` / `nvim_win_is_valid` before using them in deferred callbacks.
- API calls that change text or windows inside some callbacks (e.g. `TextChangedI`, `on_lines`, LSP handlers) may need `vim.schedule()`; "E565 / textlock" errors indicate this.
- `nvim_buf_set_lines(buf, start, end, strict, lines)`: 0-based, end-exclusive; `nvim_win_set_cursor` row is 1-based, col 0-based. Off-by-one mixups are common BROKEN items.

## Modules and requires

- `require("a.b")` resolves `lua/a/b.lua` or `lua/a/b/init.lua` on the runtimepath. Slashes work but dots are conventional (STYLE).
- `require` caches in `package.loaded`; re-sourcing a file doesn't reload modules it requires.
- `pcall(require, "x")` without handling the failure hides real errors. Fine when deliberately optional; POORLY DESIGNED when it masks a required dependency.
- Global variables leaking from modules (missing `local`) → POORLY DESIGNED (namespace collisions) — or BROKEN if two modules clobber the same global.
- Ordering: anything that must exist before plugins load (`mapleader`, `vim.g.*` plugin settings, `termguicolors` for some colorschemes) must run before `require("lazy").setup()`.

## Deprecations and removals by Neovim version

Check the user's version first. "Removed" in their version → BROKEN; merely deprecated → DEPRECATED. Removal targets change; confirm in their `:h deprecated`.

### Deprecated in 0.9
| Old | Replacement |
|---|---|
| `nvim_exec()` | `nvim_exec2()` |
| `nvim_get_hl_by_name()` / `nvim_get_hl_by_id()` | `nvim_get_hl()` |

### Deprecated in 0.10
| Old | Replacement |
|---|---|
| `vim.loop` | `vim.uv` |
| `nvim_buf_get_option` / `nvim_buf_set_option` / `nvim_win_get_option` / `nvim_win_set_option` / `nvim_get_option` / `nvim_set_option` | `nvim_get_option_value` / `nvim_set_option_value` with `{ buf = }` / `{ win = }` / `{ scope = }` |
| `vim.lsp.get_active_clients()` | `vim.lsp.get_clients()` |
| `vim.lsp.buf_get_clients(bufnr)` | `vim.lsp.get_clients({ bufnr = bufnr })` |
| `vim.tbl_islist()` | `vim.islist()` |
| `vim.tbl_flatten()` | `vim.iter(t):flatten():totable()` (note: `flatten` semantics differ for dict-like tables) |
| `vim.diagnostic.disable()` / `vim.diagnostic.is_disabled()` | `vim.diagnostic.enable(false, …)` / `vim.diagnostic.is_enabled()` |
| `vim.lsp.inlay_hint(bufnr, enable)` | `vim.lsp.inlay_hint.enable(enable, { bufnr = bufnr })` (argument order changed during 0.10 — check exact signature) |
| `vim.lsp.util.get_progress_messages()` | `vim.lsp.status()` |

### Deprecated in 0.11
| Old | Replacement |
|---|---|
| `vim.diagnostic.goto_next()` / `goto_prev()` | `vim.diagnostic.jump({ count = 1 / -1, float = true })` — `jump` doesn't open a float unless asked (behavior change if omitted) |
| `vim.fn.sign_define("DiagnosticSign…", …)` for diagnostic signs | `vim.diagnostic.config({ signs = { text = { … } } })` |
| `vim.highlight.*` (e.g. `on_yank`) | `vim.hl.*` |
| `vim.lsp.with(handler, opts)` / overriding `vim.lsp.handlers["textDocument/hover"]` for borders | pass opts to the call (`vim.lsp.buf.hover({ border = "rounded" })`) or set the `'winborder'` option |
| `client.request(...)`, `client.notify(...)`, `client.supports_method(...)` (dot-call) | `client:request(...)`, `client:supports_method(...)` (method call) |
| `vim.lsp.start_client()` | `vim.lsp.start()` |
| `vim.validate({ name = { value, type } })` table form | `vim.validate(name, value, type, optional)` |

### Removed (BROKEN on any current Neovim)
| Old | Replacement |
|---|---|
| `vim.lsp.buf.formatting()` / `formatting_sync()` / `range_formatting()` | `vim.lsp.buf.format({ async = … , range = … })` |
| `client.resolved_capabilities` | `client.server_capabilities` (different field names) |
| `vim.lsp.diagnostic.*` (show_line_diagnostics, goto_next, …) | `vim.diagnostic.*` |

### Newer than this table
For releases after 0.11, read the installed `:h news` and `:h deprecated` (or the release notes for their version). Do not assume an API is current just because it isn't listed here.
