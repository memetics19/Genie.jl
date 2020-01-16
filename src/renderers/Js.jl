module Js

import Revise
import Logging
using Genie, Genie.Renderer

const JS_FILE_EXT   = ["js.jl"]
const TEMPLATE_EXT  = [".flax.js", ".jl.js"]

const SUPPORTED_JS_OUTPUT_FILE_FORMATS = TEMPLATE_EXT

const JSString = String

const NBSP_REPLACEMENT = ("&nbsp;"=>"!!nbsp;;")

export JSString, js


"""
"""
function get_template(path::String; context::Module = @__MODULE__) :: Function
  orig_path = path

  path, extension = Genie.Renderer.view_file_info(path, SUPPORTED_JS_OUTPUT_FILE_FORMATS)

  isfile(path) || error("JS file \"$orig_path\" with extensions $SUPPORTED_JS_OUTPUT_FILE_FORMATS does not exist")

  extension in JS_FILE_EXT && return (() -> Base.include(context, path))

  f_name = Genie.Renderer.function_name(path) |> Symbol
  mod_name = Genie.Renderer.m_name(path) * ".jl"
  f_path = joinpath(Genie.config.path_build, Genie.Renderer.BUILD_NAME, mod_name)
  f_stale = Genie.Renderer.build_is_stale(path, f_path)

  if f_stale || ! isdefined(context, func_name)
    f_stale && Genie.Renderer.build_module(to_js(data), path, mod_name)

    return Base.include(context, joinpath(Genie.config.path_build, Genie.Renderer.BUILD_NAME, mod_name))
  end

  getfield(context, f_name)
end


"""
"""
function to_js(data::String; prepend = "\n") :: String
  string("function $(Genie.Renderer.function_name(data))() \n",
          Genie.Renderer.injectvars(),
          prepend,
          "\"\"\"$data\"\"\"",
          "\nend \n")
end


"""
"""
function render(data::String; context::Module = @__MODULE__, vars...) :: Function
  Genie.Renderer.registervars(vars...)

  data_hash = hash(data)
  path = "Flax_" * string(data_hash)

  func_name = Genie.Renderer.function_name(string(data_hash)) |> Symbol
  mod_name = Genie.Renderer.m_name(path) * ".jl"
  f_path = joinpath(Genie.config.path_build, Genie.Renderer.BUILD_NAME, mod_name)
  f_stale = Genie.Renderer.build_is_stale(f_path, f_path)

  if f_stale || ! isdefined(context, func_name)
    f_stale && Genie.Renderer.build_module(to_js(data), path, mod_name)

    return Base.include(context, joinpath(Genie.config.path_build, Genie.Renderer.BUILD_NAME, mod_name))
  end

  getfield(context, func_name)
end


"""
"""
function render(viewfile::Genie.Renderer.FilePath; context::Module = @__MODULE__, vars...) :: Function
  Genie.Renderer.registervars(vars...)

  get_template(string(viewfile), partial = false, context = context)
end


function render(::Type{MIME"application/javascript"}, data::String; context::Module = @__MODULE__, vars...) :: Genie.Renderer.WebRenderable
  try
    Genie.Renderer.WebRenderable(Base.invokelatest(render(data; context = context, vars...))::String, :js)
  catch ex
    isa(ex, KeyError) && Genie.Renderer.changebuilds() # it's a view error so don't reuse them
    rethrow(ex)
  end
end


function render(::Type{MIME"application/javascript"}, viewfile::Genie.Renderer.FilePath; context::Module = @__MODULE__, vars...) :: Genie.Renderer.WebRenderable
  try
    Genie.Renderer.WebRenderable(Base.invokelatest(render(viewfile; context = context, vars...))::String, :js)
  catch ex
    isa(ex, KeyError) && Genie.Renderer.changebuilds() # it's a view error so don't reuse them
    rethrow(ex)
  end
end


"""
"""
function js(data::String; context::Module = @__MODULE__, status::Int = 200, headers::Genie.Renderer.HTTPHeaders = Genie.Renderer.HTTPHeaders(), forceparse::Bool = false, vars...) :: Genie.Renderer.HTTP.Response
  if occursin(raw"$", data) || occursin("<%", data) || forceparse
    Genie.Renderer.WebRenderable(render(MIME"application/javascript", data; context = context, vars...), :js, status, headers) |> Genie.Renderer.respond
  else
    Genie.Renderer.WebRenderable(body = data, content_type = :js, status = status, headers = headers) |> Genie.Renderer.respond
  end
end


"""
"""
function js(viewfile::Genie.Renderer.FilePath; context::Module = @__MODULE__, status::Int = 200, headers::Genie.Renderer.HTTPHeaders = Genie.Renderer.HTTPHeaders(), vars...) :: Genie.Renderer.HTTP.Response
  Genie.Renderer.WebRenderable(render(MIME"application/javascript", viewfile; context = context, vars...), :js, status, headers) |> Genie.Renderer.respond
end

end