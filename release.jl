RELEASES = Set(readlines(`hub release`))
REGEX = r"^(tree_sitter.*\.v\d+\.\d+\.\d+).*$"
for dir in readdir(@__DIR__)
    if isdir(dir) && startswith(dir, "tree_sitter")
        @info dir
        isdir(joinpath(@__DIR__, dir, "products")) || continue
        cd(joinpath(@__DIR__, dir, "products")) do
            found = Dict{String,Vector{String}}()
            for file in sort(readdir(pwd()))
                m = match(REGEX, file)
                m === nothing ? nothing : push!(get!(() -> String[], found, m[1]), file)
            end
            for (tag, assets) in found
                if tag in RELEASES
                    @info "Skipping '$tag', already released."
                else
                    parts = ["hub", "release", "create"]
                    for file in assets
                        push!(parts, "-a", file)
                    end
                    push!(parts, "-m", repr(tag), tag)
                    run(Cmd(parts))
                end
            end
        end
    end
end
