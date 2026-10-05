local pins = {}

-- File to persist pins globally
local persist_file = vim.fn.stdpath("state") .. "/pins.lua"

-- Module state
pins.store = {}
pins.data = {}

-- Project root / directory key
local function get_project_key()
  return vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
end

-- Sync current project's pins into pins.data
local function sync_project()
  local key = get_project_key()
  if not pins.store[key] then
    pins.store[key] = {}
  end
  pins.data = pins.store[key]
  vim.g.pins_data = pins.data
end

-- Load pins safely from disk
local function load()
  if vim.fn.filereadable(persist_file) == 1 then
    local ok, data = pcall(dofile, persist_file)
    if ok and type(data) == "table" then
      -- Check if legacy flat table { [1] = "path" }
      local is_legacy = false
      for k, _ in pairs(data) do
        if type(k) == "number" then
          is_legacy = true
          break
        end
      end
      if is_legacy then
        pins.store = { [get_project_key()] = data }
      else
        pins.store = data
      end
    else
      pins.store = {}
    end
  else
    pins.store = {}
  end
  sync_project()
end
load()

-- Save pins to disk atomically
local function save()
  vim.g.pins_data = pins.data
  local tmp = persist_file .. ".tmp"
  local f, err = io.open(tmp, "w")
  if not f then
    vim.notify("Failed to save pins: " .. err, vim.log.levels.ERROR)
    return
  end
  f:write("return " .. vim.inspect(pins.store))
  f:close()
  os.rename(tmp, persist_file)
end

-- Validate slot number
local function valid_slot(i)
  return type(i) == "number" and i > 0 and math.floor(i) == i
end

-- Explicitly pin current buffer to slot i (overwriting if present)
function pins.pin(i)
  if not valid_slot(i) then return end
  sync_project()
  local current = vim.fn.expand("%:p")
  if current == "" then return end

  pins.data[i] = current
  save()
  vim.notify(string.format("Pinned slot [%d] -> %s", i, vim.fn.fnamemodify(current, ":~:.")), vim.log.levels.INFO)
end

-- Pin or jump
function pins.pin_or_jump(i)
  if not valid_slot(i) then return end
  sync_project()
  local current = vim.fn.expand("%:p")
  if current == "" then return end

  if pins.data[i] then
    vim.cmd("edit " .. vim.fn.fnameescape(pins.data[i]))
  else
    pins.data[i] = current
    save()
    vim.notify(string.format("Pinned slot [%d] -> %s", i, vim.fn.fnamemodify(current, ":~:.")), vim.log.levels.INFO)
  end
end

-- Clear pins
function pins.clear(i)
  sync_project()
  if i then
    if valid_slot(i) then
      pins.data[i] = nil
      save()
    end
  else
    local key = get_project_key()
    pins.store[key] = {}
    pins.data = pins.store[key]
    save()
  end
end

-- Setup keymaps and autocommands
function pins.setup(opts)
  opts = vim.tbl_extend("force", { map = false, leader = "<leader>", slots = 9 }, opts or {})

  vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("PinsSync", { clear = true }),
    callback = sync_project,
  })

  if not opts.map then return end

  for i = 1, opts.slots do
    vim.keymap.set("n", opts.leader .. i, function()
      pins.pin_or_jump(i)
    end, { desc = "Pin or jump slot " .. i })
    vim.keymap.set("n", opts.leader .. "p" .. i, function()
      pins.pin(i)
    end, { desc = "Set pin slot " .. i })
    vim.keymap.set("n", opts.leader .. "0" .. i, function()
      pins.clear(i)
    end, { desc = "Clear pin slot " .. i })
  end
end

return pins


