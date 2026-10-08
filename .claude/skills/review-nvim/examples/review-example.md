# Worked example

Calibrates length, tone, selection, and stopping. The annotations (in blockquotes) are for you, not the user.

## Input

User: "Review my nvim config." Neovim 0.11 (from `nvim --version`).

```lua
-- init.lua
vim.opt.number = true
vim.cmd("set relativenumber")
require("config.lazy")          -- calls require("lazy").setup("plugins")
vim.g.mapleader = " "
require("config.options")
```

```lua
-- lua/config/options.lua
if vim.fn.has("win32") then
  vim.opt.shell = "pwsh"
end
vim.opt.tabstop = 4
```

```lua
-- lua/plugins/editor.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", require("telescope.builtin").find_files, desc = "Find files" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = { numhl = true },
    config = function()
      require("gitsigns").setup({ current_line_blame = true })
    end,
  },
}
```

> **Private inventory (never shown):**
> 1. `vim.fn.has("win32")` truthiness → `shell = pwsh` on every OS → `:!`, `system()`, and plugins that shell out fail on Linux/macOS. BROKEN, P1, wide blast radius.
> 2. `mapleader` set after `lazy.setup` → `<leader>ff` from the `keys` spec is bound to `\ff`. BROKEN, P1.
> 3. gitsigns `opts` ignored because `config` is a function that doesn't use it → `numhl` never enabled. BROKEN, P1 — but narrower impact.
> 4. `require("telescope.builtin")` evaluated at spec time → telescope loads at startup. POORLY DESIGNED, P3.
> 5. `vim.cmd("set relativenumber")` next to `vim.opt.number` → STYLE. Not presented.
>
> **Selection:** three P1s. Tie-break by blast radius: #1 breaks every shell-out on non-Windows; #2 breaks all leader mappings defined by specs. #3 affects one cosmetic option. Present #1 and #2 (independent of each other). #3 and #4 wait for "continue". #5 is never raised unless the user asks about style.

## Output

## Issue — Windows shell check is always true

**Classification:** BROKEN

**Priority:** 1

**Location:** `lua/config/options.lua:1-3`
```lua
if vim.fn.has("win32") then
  vim.opt.shell = "pwsh"
end
```

**What is happening:** `vim.fn.has()` returns the number `0` or `1`. In Lua, `0` is truthy, so this condition is true on every operating system and `shell` is set to `pwsh` everywhere.

**Why this matters:** On Linux/macOS without PowerShell installed, `:!cmd`, `vim.fn.system()`, and any plugin that shells out through `'shell'` will fail with an error about `pwsh` not being executable.

**Recommended change:**
```lua
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "pwsh"
end
```

**Why this is better:** It compares against the actual return value, so the override applies only on Windows, which is what the condition was written to express.

**Behavior change:** Yes — on non-Windows systems `'shell'` returns to its default (your `$SHELL`) instead of `pwsh`. Windows is unchanged.

## Issue — Leader is set after plugin keymaps are created

**Classification:** BROKEN

**Priority:** 1

**Location:** `init.lua:3-4`
```lua
require("config.lazy")          -- calls require("lazy").setup("plugins")
vim.g.mapleader = " "
```

**What is happening:** `<leader>` is expanded when a mapping is created. lazy.nvim creates the mappings from `keys` specs during `setup()`, which runs on line 3 — before the leader is changed to Space on line 4. At that moment the leader is still the default `\`.

**Why this matters:** `<leader>ff` from the telescope spec is actually bound to `\ff`; pressing Space then `ff` does nothing. Every leader mapping defined in a plugin spec has the same problem. lazy.nvim's own setup instructions say to set the leader before calling `setup`.

**Recommended change:**
```lua
vim.g.mapleader = " "
require("config.lazy")          -- calls require("lazy").setup("plugins")
require("config.options")
```

**Why this is better:** The leader is defined before anything creates a leader mapping, so every mapping — in specs and elsewhere — uses Space.

**Behavior change:** Yes — spec-defined leader mappings move from `\` to Space, as intended.

> **End of response.** No "I also noticed gitsigns…", no "next time we can look at…", no summary.

## Counter-examples (what not to produce)

- Listing all five findings with fixes.
- Converting the gitsigns `config` to `opts` *and* the telescope keys *and* adding an augroup in the same answer.
- Flagging `vim.cmd("set relativenumber")` as "DEPRECATED" or "POORLY DESIGNED" — it is supported; at most STYLE.
- Rewriting `init.lua` into a new module layout while fixing the leader order.
- Recommending `vim.diagnostic.jump` to a user on Neovim 0.10, where it doesn't exist.
