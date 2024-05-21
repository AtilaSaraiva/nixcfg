#! /usr/bin/env lua

local os = require("os")
local io = require("io")
local lfs = require("lfs")

-- Function to get command line arguments
local function get_arg(index)
    return arg[index]
end

-- Get flake_path from command line or default to the current directory
local flake_path = get_arg(1) or lfs.currentdir()

-- Define the paths
local hostname = io.popen("hostname"):read("*l")
local julia_env_path = os.getenv("HOME") .. "/.julia/environments"
local projects_path = os.getenv("HOME") .. "/Files/Mega/phd/projects/julia"

-- Function to run a shell command and print output
local function run_command(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    print(result)
end

-- Function to check if a file exists
local function file_exists(file)
    local f = io.open(file, "r")
    if f then f:close() end
    return f ~= nil
end

-- Function to recursively find and precompile Julia environments
local function precompile_julia_environments(path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local fullpath = path .. '/' .. file
            local attr = lfs.attributes(fullpath)
            if attr.mode == "directory" then
                -- Recursively search in subdirectories
                precompile_julia_environments(fullpath)
            elseif file == "Project.toml" then
                -- Precompile the environment if Project.toml is found
                local env_path = path
                print("Precompiling environment: " .. env_path)
                run_command('julia --project="' .. env_path .. '" -e "using Pkg; Pkg.precompile()"')
            end
        end
    end
end

-- Run home-manager switch
print("Running home-manager switch...")
run_command('home-manager switch --flake ' .. flake_path .. '#atila@' .. hostname)

-- Precompile Julia environments
print("Precompiling Julia environments in " .. julia_env_path)
precompile_julia_environments(julia_env_path)

print("Precompiling Julia environments in " .. projects_path)
precompile_julia_environments(projects_path)

print("Done.")
