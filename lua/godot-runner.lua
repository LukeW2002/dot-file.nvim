-- Add this to a new file: lua/godot-runner.lua

local M = {}

-- Function to find Godot project root
local function find_godot_project()
  local current_dir = vim.fn.expand('%:p:h')
  local project_file = vim.fn.findfile('project.godot', current_dir .. ';')
  if project_file ~= '' then
    return vim.fn.fnamemodify(project_file, ':h')
  end
  return nil
end

-- Function to run Godot project
function M.run_project()
  local project_dir = find_godot_project()
  if not project_dir then
    vim.notify("No Godot project found (no project.godot file)", vim.log.levels.ERROR)
    return
  end
  
  -- Change to project directory and run Godot
  local cmd = string.format('cd "%s" && godot --path . &', project_dir)
  vim.fn.system(cmd)
  vim.notify("Running Godot project from: " .. project_dir, vim.log.levels.INFO)
end

-- Function to run current scene
function M.run_current_scene()
  local project_dir = find_godot_project()
  if not project_dir then
    vim.notify("No Godot project found", vim.log.levels.ERROR)
    return
  end
  
  local current_file = vim.fn.expand('%:p')
  local scene_file = current_file:gsub('%.gd$', '.tscn')
  
  if vim.fn.filereadable(scene_file) == 1 then
    local relative_scene = vim.fn.fnamemodify(scene_file, ':.')
    local cmd = string.format('cd "%s" && godot --path . "%s" &', project_dir, relative_scene)
    vim.fn.system(cmd)
    vim.notify("Running scene: " .. relative_scene, vim.log.levels.INFO)
  else
    vim.notify("No corresponding .tscn file found for current script", vim.log.levels.WARN)
    M.run_project() -- Fall back to running the whole project
  end
end

-- Function to export project
function M.export_project()
  local project_dir = find_godot_project()
  if not project_dir then
    vim.notify("No Godot project found", vim.log.levels.ERROR)
    return
  end
  
  local export_dir = project_dir .. "/export"
  vim.fn.mkdir(export_dir, "p")
  
  local cmd = string.format('cd "%s" && godot --headless --export-debug "macOS" "%s/game.zip" &', 
                           project_dir, export_dir)
  vim.fn.system(cmd)
  vim.notify("Exporting project to: " .. export_dir, vim.log.levels.INFO)
end

-- Function to open Godot editor
function M.open_editor()
  local project_dir = find_godot_project()
  if not project_dir then
    vim.notify("No Godot project found", vim.log.levels.ERROR)
    return
  end
  
  local cmd = string.format('cd "%s" && godot --editor --path . &', project_dir)
  vim.fn.system(cmd)
  vim.notify("Opening Godot editor for: " .. project_dir, vim.log.levels.INFO)
end

-- Function to kill all Godot processes
function M.kill_godot()
  vim.fn.system('pkill -f godot')
  vim.notify("Killed all Godot processes", vim.log.levels.INFO)
end

return M
