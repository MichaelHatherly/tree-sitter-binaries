using Pkg.Artifacts

"--verbose" in ARGS || push!(ARGS, "--verbose")

REMOTE = "https://github.com/MichaelHatherly/tree-sitter-binaries/releases/download"
REGEX = r"^(tree_sitter.*\.v\d+\.\d+\.\d+).*$"
ARTIFACT_TOML = joinpath(@__DIR__, "Artifacts.toml")
BUILD = [
]

for dir in readdir(@__DIR__)
    if isdir(dir) && startswith(dir, "tree_sitter")
        if chop(dir; head=length("tree_sitter_"), tail=0) ∉  BUILD
            @warn "skipping $dir"
        else
            @info "Building '$dir'..."
            cd(joinpath(@__DIR__, dir)) do
                products = include(joinpath(pwd(), "build_tarballs.jl"))
                for (triple, (file, hash, sha, dict)) in products
                    _, file = splitdir(file)
                    m = match(REGEX, file)
                    info = ("$REMOTE/$(m[1])/$file", hash)
                    bind_artifact!(ARTIFACT_TOML, dir, sha, platform=triple, force=true, download_info=Tuple[info])
                end
            end
        end
    end
end
