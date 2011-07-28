type plugin =
  { name : string
  ; files : list(string)
  }

type example =
  { name : string
  ; port : int
  ; srcs : stringmap(Resource.resource)
  ; article : blog_article
  ; plugins : list(plugin)
  }

Examples = {{

  compilation_cmd(e : example, compiler_options, plugin_builder_options) : list(string) =
    opack = "{e.name}.opack"
    opa = "{e.name}.opa"
    files = if Map.mem("{e.name}/{opack}", e.srcs) then opack else opa
    build_plugin(p) =
      files = List.to_string_using("", "", " ", p.files)
      "opa-plugin-builder {files} -o {p.name} {plugin_builder_options}"
    build_plugins = List.map(build_plugin, e.plugins)
    compile = "opa {files} {compiler_options}"
    build_plugins ++ [compile]

  compile(e : example) : void =
    cmds = compilation_cmd(e, "", "")
    cmd = List.to_string_using("", "", " && ", cmds)
    do Log.info("HOP", "Compiling <{e.name}>... [{cmd}]")
    %%Bash.execute%%("cd {e.name} && {cmd}")

  compile_all = List.iter(compile, _)

}}
