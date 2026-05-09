{pkgs, ...}:

{
  programs.opencode = {
    enable = true;
    agents = {
      manager = {
        description = "Primary agent that delegates tasks to other models";
        mode = "primary";
        model = "opencode/gemini-3.1-pro";
        prompt = ''
        '';
        temperature = 0.2;
        tools = {
          write = false;
          edit = false;
          bash = true;
        };
      };
      explorer = {
        description = "Fast agent for analysing code bases";
        mode = "primary";
        model = "opencode/gpt-5.4-mini";
        prompt = ''
        '';
        temperature = 0.4;
        tools = {
          write = false;
          edit = false;
          bash = false;
        };
      };
      coder = {
        description = "Coding agent using Claude Opus";
        mode = "subagent";
        model = "opencode/claude-opus-4-7";
        temperature = 0.5;
        tools = {
          write = true;
          edit = true;
          bash = true;
        };
      };
      researcher = {
        description = "Research agent for real-time web search";
        mode = "subagent";
        model = "opencode/kimi-k2.6";
        temperature = 0.8;
        tools = {
          write = false;
          edit = false;
          bash = false;
        };
      };
      debugger = {
        description = "Debug and testing agent using GPT-5.1 Codex";
        mode = "subagent";
        model = "opencode/gpt-5.3-codex";
        temperature = 0.3;
        tools = {
          write = true;
          edit = true;
          bash = true;
        };
      };
    };
  };  
}
