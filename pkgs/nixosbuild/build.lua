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
local flake_output = get_arg(2) or "atila@" .. io.popen("hostname"):read("*l")
local julia_env_path = get_arg(3) or os.getenv("HOME") .. "/.julia/environments"

-- Function to run a shell command and return the exit status
local function run_command(command)
    print("Running command: " .. command)
    local result = os.execute(command)
    return result == 0  -- Check if the command was successful
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
local switch_success = run_command('home-manager switch --flake ' .. flake_path .. '#' .. flake_output)

-- If home-manager switch is successful, proceed to precompile Julia environments
if switch_success then
    print("Precompiling Julia environments in " .. julia_env_path)
    precompile_julia_environments(julia_env_path)
else
    print("Home-manager switch failed. Skipping Julia precompilation.")
end

print("Done.")
