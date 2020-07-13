for dir in readdir(@__DIR__)
    if isdir(dir) && startswith(dir, "tree_sitter")
        cd(joinpath(@__DIR__, dir)) do
            @info dir
            rm("build"; force=true, recursive=true)
            rm("products"; force=true, recursive=true)
        end
    end
end
rm(joinpath(@__DIR__, "Artifacts.toml"); force=true)
