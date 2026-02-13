return {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = "clippy"
      },
      diagnostics = {
        enable = true,
      }
    }
  }
}
