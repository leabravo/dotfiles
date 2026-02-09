local pins = {}

-- File to persist pins globally
local persist_file = vim.fn.stdpath("state") .. "/pins.lua"

-- Module state
pins.data = {}

-- Load pins safely from disk
local function load()
  if vim.fn.filereadable(persist_file) == 1 then
    local ok, data = pcall(dofile, persist_file)
    if ok and type(data) == "table" then
      pins.data = data
    else
      pins.data = {}
    end
  else
    pins.data = {}
  end
  vim.g.pins_data = pins.data
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
  f:write("return " .. vim.inspect(pins.data))
  f:close()
  os.rename(tmp, persist_file)
end

-- Validate slot number
local function valid_slot(i)
  return type(i) == "number" and i > 0 and math.floor(i) == i
end

-- Pin or jump
function pins.pin_or_jump(i)
  if not valid_slot(i) then return end
  local current = vim.fn.expand("%:p")
  if current == "" then return end

  if pins.data[i] then
    vim.cmd("edit " .. vim.fn.fnameescape(pins.data[i]))
  else
    pins.data[i] = current
    save()
  end
end

-- Clear pins
function pins.clear(i)
  if i then
    if valid_slot(i) then
      pins.data[i] = nil
      save()
    end
  else
    pins.data = {}
    save()
  end
end

-- Setup keymaps
function pins.setup(opts)
  opts = vim.tbl_extend("force", { map = false, leader = "<leader>", slots = 9 }, opts or {})
  if not opts.map then return end

  for i = 1, opts.slots do
    vim.keymap.set("n", opts.leader .. i, function()
      pins.pin_or_jump(i)
    end, { desc = "Pin or jump slot " .. i })
    vim.keymap.set("n", opts.leader .. "0" .. i, function()
      pins.clear(i)
    end, { desc = "Clear pin slot " .. i })
  end
end

return pins

