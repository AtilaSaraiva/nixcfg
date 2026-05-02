if isinteractive()
    @eval using OhMyREPL
    @eval using Revise
    @eval using Infiltrator
    @eval using Debugger, JuliaInterpreter, MethodAnalysis;
    union!(JuliaInterpreter.compiled_modules, child_modules(Base));
    visit(Base) do item
        isa(item, Module) && push!(JuliaInterpreter.compiled_modules, item)
        true
    end
end

function inc(file::String)
    Base.run(`clear`)
    include(file)
end

function pluto()
    @eval using Pluto
    @eval Pluto.run(launch_browser=false,
                    host=read(`tailscale ip --4`, String) |> strip |> string,
                    require_secret_for_open_links=false,
                    require_secret_for_access=false)
end


"""
    plotit(array, d, o; width=95)

Plot the 2D array `array` as a heatmap, using

  • grid spacings  d = (dx, dy)
  • origin         o = (x0, y0)

so that

  xᵢ = x0 + (i-1)*dx   for i=1:size(array,2)
  yⱼ = y0 + (j-1)*dy   for j=1:size(array,1)

Keyword `width` is passed through to UnicodePlots.
"""
function plotit(
    array::AbstractMatrix{<:Real};
    d::Tuple{<:Real,<:Real}=(10,10),
    o::Tuple{<:Real,<:Real}=(0,0),
    width::Int = 95
)

    @eval import UnicodePlots as uniplots

    dy, dx = d
    y0, x0 = o

    uniplots.heatmap(
        array;
        yfact = dy,
        xfact = dx,
        yoffset = y0,
        xoffset = x0,
        width = width,
        yflip = true,
        xlabel = "x",
        ylabel = "y",
        title  = ""
    )
end

function __calculate_pclip(A::AbstractArray{<:Real}; pclip=98)
    @eval using Statistics: quantile
    if (pclip<=100)
        a = -quantile(abs.(A[:]), (pclip/100))
    else
        a = -quantile(abs.(A[:]), 1)*pclip/100
    end
    b = -a

    return a, b
end

function plotit(
    array::AbstractMatrix{<:Real},
    pclip::Integer;
    d::Tuple{<:Real,<:Real},
    o::Tuple{<:Real,<:Real},
    width::Int = 95
)

    @eval using UnicodePlots

    a,b = __calculate_pclip(array)

    dy, dx = d
    y0, x0 = o

    heatmap(
        array;
        zlim=(a,b),
        yfact = dy,
        xfact = dx,
        yoffset = y0,
        xoffset = x0,
        width = width,
        yflip = true,
        xlabel = "x",
        ylabel = "y",
        title  = ""
    )
end

"""
    converts a figure size in cm to pixels for Makie plotting
"""
function resolution_from_cm(x::Real, y::Real; dpi::Int=300)
    cm_to_inches(x) = 0.3937007874*x
    size_in_inches = Int.(round.(cm_to_inches.(size_in_cm)))
    size_in_pixels = size_in_inches .* dpi
    return size_in_pixels
end

function template()
    @eval begin
        using PkgTemplates
        tpl = Template(;
           user = "AtilaSaraiva",
           dir="/home/atila/Files/synced/phd/projects/julia/",
           authors="Átila Saraiva Quintela Soares",
           julia=v"1.10",
           plugins=[License(name="MIT"),
               Git(; manifest=true, ssh=true),
               Codecov(),
               Documenter{GitHubActions}(),
               CompatHelper(),
               TagBot(),
               RegisterAction(),
               ProjectFile(version=v"0.1.0"),
           ])
    end
end


if Base.isinteractive() &&
   (local REPL = get(Base.loaded_modules, Base.PkgId(Base.UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), "REPL"), nothing); REPL !== nothing)

    # Exit Julia with :q, restart with :r
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        function toplevel_quotenode(ast, s)
            return (Meta.isexpr(ast, :toplevel, 2) && ast.args[2] === QuoteNode(s)) ||
                   (Meta.isexpr(ast, :toplevel) && any(x -> toplevel_quotenode(x, s), ast.args))
        end
        if toplevel_quotenode(ast, :q)
            exit()
        elseif toplevel_quotenode(ast, :r)
            argv = Base.julia_cmd().exec
            opts = Base.JLOptions()
            if opts.project != C_NULL
                push!(argv, "--project=$(unsafe_string(opts.project))")
            end
            if opts.nthreads != 0
                push!(argv, "--threads=$(opts.nthreads)")
            end
            # @ccall execv(argv[1]::Cstring, argv::Ref{Cstring})::Cint
            ccall(:execv, Cint, (Cstring, Ref{Cstring}), argv[1], argv)
        end
        return ast
    end)

    # Automatically load tooling on demand:
    # - BenchmarkTools.jl when encountering @btime or @benchmark
    # - Cthulhu.jl when encountering @descend(_code_(typed|warntype))
    # - Debugger.jl when encountering @enter or @run
    # - Profile.jl when encountering @profile
    # - ProfileView.jl when encountering @profview
    # - Test.jl when encountering @test, @testset, @test_xxx, ...
    local tooling_dict = Dict{Symbol,Vector{Symbol}}(
        :BenchmarkTools => Symbol.(["@btime", "@benchmark"]),
        :Cthulhu        => Symbol.(["@descend", "@descend_code_typed", "@descend_code_warntype"]),
        :Debugger       => Symbol.(["@enter", "@run"]),
        :Profile        => Symbol.(["@profile"]),
        :ProfileView    => Symbol.(["@profview"]),
        :Test           => Symbol.([
                               "@test", "@testset", "@test_broken", "@test_deprecated",
                               "@test_logs", "@test_nowarn", "@test_skip",
                               "@test_throws", "@test_warn", "@inferred"
                           ]),
    )
    pushfirst!(REPL.repl_ast_transforms, function(ast::Union{Expr,Nothing})
        function contains_macro(ast, m)
            return ast isa Expr && (
                (Meta.isexpr(ast, :macrocall) && ast.args[1] === m) ||
                any(x -> contains_macro(x, m), ast.args)
            )
        end
        for (mod, macros) in tooling_dict
            if any(contains_macro(ast, s) for s in macros) && !isdefined(Main, mod)
                @info "Loading $mod ..."
                try
                    Core.eval(Main, :(using $mod))
                catch err
                    @info "Failed to automatically load $mod" exception=err
                end
            end
        end
        return ast
    end)

end
