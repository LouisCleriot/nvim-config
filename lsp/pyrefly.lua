return {
  cmd = { "pyrefly" , "lsp"},
  filetypes = { "python" },
  root_markers = { ".git", "pyproject.toml", "setup.py" },
  settings = {
    -- Pyrefly specific settings go here
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      }
    }
  }
}
