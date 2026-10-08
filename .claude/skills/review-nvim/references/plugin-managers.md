# Plugin managers: lazy.nvim and packer.nvim

Read when reviewing plugin specs, lazy-loading, or load order. Confirm details against the installed lazy.nvim docs (`~/.local/share/nvim/lazy/lazy.nvim/README.md` or `doc/lazy.nvim.txt`) if a claim is load-bearing.

**Never propose migrating between managers as a fix.**

## lazy.nvim spec semantics

### `opts`, `config`, `main`
- If `config` is **not** a function and either `opts` is set or `config = true`: lazy calls `require(main).setup(opts)` when the plugin loads.
- If `config` **is** a function: lazy calls `config(plugin, opts)` and does **not** call `setup` for you. A spec with both `opts = {…}` and `config = function() require("x").setup({…}) end` silently ignores `opts` — BROKEN if those options would change behavior. Minimal fix: `config = function(_, opts) require("x").setup(opts) end` with the options moved into `opts`, or merge them — whichever preserves the effective settings.
- `main`: module name used for `setup`. Auto-detected from the plugin name; set it explicitly when detection is wrong (e.g. a plugin whose Lua module name differs from the repo name).
- `opts` may be a table (deep-merged with other specs for the same plugin) or a function `function(plugin, opts)` that mutates `opts` or returns a new table.

### When `config = function` → `opts` is valid
Only when **all** hold:
1. The plugin exposes `require(main).setup(tbl)` (check the plugin's README/source).
2. The config function does nothing but call that `setup` with a static table (no other `require`s, keymaps, autocmds, extensions, or computed values that depend on load-time state).
3. The table moved into `opts` is identical.
Vimscript plugins, plugins configured via `vim.g` variables, and plugins with no `setup` must **not** be given `opts = {}` / `config = true` — lazy will try to `require` a module that doesn't exist or call a nonexistent `setup` (error). Converting a working `config` to `opts` is at most STYLE unless it fixes a real problem.

### `init`
- Runs **at startup**, before the plugin loads, even for lazy-loaded plugins.
- Correct place for `vim.g.<plugin>_*` settings that a Vimscript plugin reads on load. Putting them in `config` (which runs after the plugin's `plugin/` files are sourced) can be too late → BROKEN.
- Calling `require("plugin")` inside `init` loads the plugin eagerly, defeating lazy-loading.

### Lazy-loading triggers
- `event`, `cmd`, `ft`, `keys` each make the plugin lazy. `lazy = true` with no trigger → loads only when another plugin or code `require`s it.
- `event = "VeryLazy"` fires after startup UI. Anything that must act on the **first** buffer (LSP attach, filetype-specific setup) can miss buffers already open when it loads — e.g. lspconfig setup on `VeryLazy` doesn't attach to the file passed on the command line. BROKEN if it causes that miss. `BufReadPre`/`BufNewFile` is the usual choice for LSP setup.
- `keys`: lazy creates stub mappings at setup; first press loads the plugin and replays the key. `rhs` written as `require("telescope.builtin").find_files` (not wrapped in a function) is evaluated when the spec is read → loads the plugin at startup (POORLY DESIGNED, P3) or errors if the module isn't on the path yet (BROKEN).
- `cmd`: stub commands are created; completion for the real command only works after load.
- `ft`: loads on matching `FileType`.
- Any top-level `require("some_plugin")` outside a function (in spec files, `init.lua`, or option modules) loads that plugin immediately via lazy's require hook — cancels its lazy-loading.
- Changing triggers changes *when* commands/mappings exist → state **Behavior change: Yes**.

### Colorschemes
- The active colorscheme plugin should be `lazy = false, priority = 1000` (loaded first). A lazy-loaded colorscheme referenced by `vim.cmd.colorscheme` at startup errors or flashes the default (BROKEN / P1 if it errors).

### `dependencies`
- Listed plugins are loaded **before** the dependent plugin when it loads. A plugin that appears only as a dependency is lazy by default.
- Dependencies are not a substitute for ordering between independent eagerly loaded plugins — use `priority` (for `lazy = false` plugins) or explicit triggers.
- Strings like `"nvim-lua/plenary.nvim"` inside `dependencies` are full specs; config for them can live there or in their own spec (they merge).

### Spec merging
- The same plugin may appear in several specs (e.g. a base spec and an override). They merge: `opts` deep-merges (or the `opts` function receives the merged table); list-like fields such as `dependencies`, `cmd`, `event`, `ft`, `keys` are extended; most scalar fields are overridden by the later spec. Check lazy's docs before claiming a specific override result.
- An override that sets `config = function` without using `opts` discards all merged `opts` — common bug in distro-based configs (LazyVim, etc.).

### Other fields
- `build` (string command like `":TSUpdate"`, shell command, or function) — runs on install/update.
- `version`, `branch`, `tag`, `commit`, `pin` — pinning. Changing them is a behavior change.
- `enabled` / `cond` — `enabled = false` removes the plugin from the spec; `cond = false` keeps it installed but not loaded.
- `name` — needed when two plugins would collide or for local `dir` plugins.
- Packer keys inside a lazy spec (`requires`, `run`, `after`, `as`, `opt`, `module`, `setup`, `disable`) are not lazy.nvim fields; their intent is not carried out (dependency not loaded, build not run, etc.). BROKEN when that intent matters. `:checkhealth lazy` reports some invalid spec fields — use it to confirm.

| packer | lazy.nvim equivalent |
|---|---|
| `requires` | `dependencies` |
| `run` | `build` |
| `setup` (runs before load) | `init` |
| `config` | `config` |
| `as` | `name` |
| `opt = true` | `lazy = true` |
| `disable = true` | `enabled = false` |
| `after` | usually `dependencies`; no direct equivalent |
| `module` | not needed (lazy loads on `require`) |

### Load order at startup
1. `init.lua` top-level code up to `require("lazy").setup(...)`.
2. lazy reads all specs (top-level code in spec files runs **now**), runs every `init`, creates `keys`/`cmd`/event stubs, loads `lazy = false` plugins in `priority` order and runs their `config`.
3. Remaining `init.lua` code.
4. Startup events (`VimEnter`, `UIEnter`, then `VeryLazy`).
Anything that must be in place for step 2 (notably `vim.g.mapleader` / `maplocalleader`) must happen in step 1.

## packer.nvim

- packer.nvim is archived (unmaintained since 2023). Using it is not, by itself, an issue to raise in a normal review; do not propose migration unless asked.
- `config` and `setup` functions are **compiled** into `packer_compiled.lua` via `string.dump`; they **cannot reference upvalues** (locals from the enclosing file). A `config` using a local defined outside it fails at load (BROKEN). Fix: `require` the needed module inside the function, or use a string: `config = [[require("x").setup()]]`.
- After editing specs, `:PackerCompile` (or `:PackerSync`) must run; a stale `packer_compiled.lua` means changes don't take effect. Suggest an autocmd only if the user keeps hitting this — otherwise it's a workflow note, not a defect.
- `after = "plugin-name"` matches packer's short name (or `as`); misspelling silently prevents load.
- `opt = true` without a trigger (`cmd`, `ft`, `event`, `keys`, `module`) → plugin never loads unless `:packadd`ed.
