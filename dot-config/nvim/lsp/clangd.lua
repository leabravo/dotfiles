return {
    -- The command to start the language server. Ensure 'clangd' is in your PATH.
    cmd = { "clangd", "--background-index", "--clang-tidy", "--suggest-missing-includes" },
    
    -- List of filetypes for which this server should be enabled.
    filetypes = { "c", "cpp", "objc", "objcpp" },
    
    -- Root directory markers to determine the project root.
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git", "Makefile" },
    
    -- Optional: additional configuration options
    settings = {
        -- Example settings:
        clangd = {
            arguments = {
                '--clang-tidy-checks=*'
            },
        },
    },
}
