return {
  cmd = { 
    "clangd", 
    "--background-index", 
    "--clang-tidy", 
    "--completion-style=detailed", 
    "--header-insertion=iwyu" 
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
