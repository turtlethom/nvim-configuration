# Plugin-specific configuration models

How particular plugins expect to be configured, and known breaking changes. These plugins change often: confirm against the **installed** version (its README / `doc/` / source, and the commit or branch in `lazy-lock.json`) before classifying anything as BROKEN or DEPRECATED. Entries flagged *(verify)* changed recently enough that the user's version decides the answer.

For a plugin not listed here: read its README and `setup`/defaults source before judging any option or pattern. Never assume it follows the `require(x).setup(opts)` convention.

## Vimscript and `vim.g`-configured plugins
(e.g. vim-fugitive, vim-surround, vimtex, vim-sleuth, many older plugins)
- Often have **no Lua module and no `setup()`**. `opts = {}` or `config = true` makes lazy try to `require` them → error.
- Settings are global variables read when the plugin's `plugin/` files are sourced. Set them in lazy's `init` (before load), not `config` (after load) — late settings may be ignored (BROKEN if they change behavior).

## nvim-lspconfig *(verify)*
- Neovim 0.11 added `vim.lsp.config(name, cfg)` and `vim.lsp.enable(name)`. nvim-lspconfig v2+ ships server definitions usable by that API, and its legacy `require("lspconfig")[server].setup({...})` framework is deprecated on Neovim ≥ 0.11 (it may emit deprecation warnings depending on the version). On Neovim < 0.11, `setup()` is the only option — recommending `vim.lsp.config` there would break.
- When flagging the legacy framework as DEPRECATED, the minimal fix is per-server: `vim.lsp.config("lua_ls", { settings = … })` + `vim.lsp.enable("lua_ls")`, carrying over `settings`, `capabilities`, `on_attach`, `filetypes`, `root_dir` semantics. `root_dir` function signatures differ between the two APIs — check before moving it. If the user's config passes many options, present one server as the worked change rather than migrating all at once.
- `on_attach` vs an `LspAttach` autocmd: both supported — STYLE.
- Capabilities from nvim-cmp: `require("cmp_nvim_lsp").default_capabilities()`. The old `update_capabilities()` was removed (BROKEN).
- Setting up the same server twice (e.g. manual `setup` plus mason-lspconfig auto-setup/enable) → two clients attach; duplicate diagnostics/completions (BROKEN).

## mason.nvim / mason-lspconfig.nvim *(verify)*
- mason-lspconfig v2 (2025) requires Neovim 0.11+ and nvim-lspconfig v2, removed `setup_handlers()`, and enables installed servers automatically via `automatic_enable` (which uses `vim.lsp.enable`). A config calling `setup_handlers` on v2 errors (BROKEN). On v1 it's valid.
- Order: `mason` setup before `mason-lspconfig` setup before server configuration. Out-of-order setup can leave servers off `PATH` at attach time.
- mason package names differ from lspconfig server names (`lua-language-server` vs `lua_ls`); `ensure_installed` in mason-lspconfig uses lspconfig names.

## nvim-treesitter *(verify branch)*
- Two incompatible branches. `master` (legacy, frozen): `require("nvim-treesitter.configs").setup({ ensure_installed, highlight = { enable = true }, … })`. `main` (rewrite): no `configs` module; parsers installed with `require("nvim-treesitter").install({...})`; highlighting is started per buffer with `vim.treesitter.start()` (typically from a `FileType` autocmd); indent via `indentexpr`. The `configs.setup` form on `main` errors (BROKEN).
- Check `lazy-lock.json` for the branch before saying anything about API.
- lazy.nvim spec on `master` needs `main = "nvim-treesitter.configs"` to use `opts` (otherwise lazy calls `require("nvim-treesitter").setup`, which doesn't take those options).
- `build = ":TSUpdate"` is expected. Lazy-loading treesitter has been discouraged by the plugin's own docs; check the README for the branch in use before recommending lazy-loading it.
- Modules like `textobjects`, `context`, `refactor` are separate plugins with their own config; on `master`, `textobjects` options went inside `configs.setup`.

## nvim-cmp *(verify for snippet behavior)*
- Requires `cmp.setup({ sources = …, mapping = … })`; mappings via `cmp.mapping.*` / `cmp.mapping.preset.insert({…})`.
- `snippet.expand` has historically been required; without a snippet engine, LSP snippet completions fail. Newer versions may fall back to `vim.snippet` on Neovim 0.10+ — check the installed version before calling its absence BROKEN.
- Source order in `sources` sets priority; grouped arrays (`cmp.config.sources({...}, {...})`) define fallback groups. Reordering is a behavior change.
- Sources (`cmp-nvim-lsp`, `cmp-buffer`, …) must be installed as plugins, typically as `dependencies`.
- Mappings defined with plain `vim.keymap.set` for `<Tab>` in insert mode conflict with cmp's mapping; last definition wins.

## telescope.nvim
- `keys` rhs `require("telescope.builtin").find_files` evaluated at spec time → eager load (see plugin-managers.md). Wrap in `function() … end`.
- Extensions: `require("telescope").load_extension("fzf")` must run **after** `telescope.setup()`; extension plugins (e.g. `telescope-fzf-native.nvim`) need `build = "make"` (or cmake) and must be installed.
- `telescope.setup({ defaults = …, pickers = …, extensions = … })` — extension config goes under `extensions.<name>`, not top level.

## which-key.nvim *(verify)*
- v3 (2024) replaced the mapping spec: `wk.register({...})` is deprecated in favor of `wk.add({ { "<leader>f", group = "file" }, … })`. Several `setup` option names changed (e.g. `window` → `win`). On v3, old-style config emits deprecation warnings (DEPRECATED); some old options are silently ignored (BROKEN if they mattered).
- which-key reads `desc` from regular keymaps; adding `desc` to `vim.keymap.set` is enough for labels — a separate which-key registration duplicating them is POORLY DESIGNED (divergence risk), priority 4.

## null-ls.nvim / none-ls.nvim
- null-ls is archived. none-ls is a maintained fork that keeps the `require("null-ls")` module name.
- none-ls removed a number of builtins (moved to `none-ls-extras.nvim` or dropped). Referencing a removed builtin (e.g. some linters/formatters) → error on setup (BROKEN). Check the installed `lua/null-ls/builtins/` tree.
- Don't recommend switching to a different formatter/linter plugin as a fix.

## Formatting (conform.nvim, LSP formatting)
- Two format-on-save mechanisms at once (e.g. conform's `format_on_save` **and** a `BufWritePre` autocmd calling `vim.lsp.buf.format`) → formats twice with possibly different tools; can fight or reorder edits (BROKEN if results differ, else POORLY DESIGNED P3).
- `vim.lsp.buf.format()` with several capable clients attached prompts or formats with all of them unless `filter`/`name` is given.
- conform.nvim: `formatters_by_ft` keys are filetypes; formatter names must match conform's registry or a custom `formatters` entry; a missing executable is reported by `:ConformInfo`.

## Colorschemes and UI plugins
- Colorscheme plugin: `lazy = false, priority = 1000`; `setup()` (if the scheme has one) must run **before** `vim.cmd.colorscheme(...)`.
- `termguicolors` should be set before the colorscheme and before UI plugins that cache highlight groups (on Neovim 0.10+ it's auto-detected in many terminals; setting it explicitly is fine).
- Statusline/bufferline plugins usually expect `opts` via `setup`; check before claiming an option exists.
