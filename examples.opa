import stdlib.system

type plugin =
  { name : string
  ; files : list(string)
  }

type example_details = {invisible} / {descr : xhtml; deps : list(example)}

type example =
  { name : string
  ; port : int
  ; srcs : stringmap(Resource.resource)
  ; article : option(article)
  ; details : example_details
  }

Examples = {{

  execute = %%Bash.execute%%
  execute_parallel = %%Bash.execute_parallel%%

  compilation_instructions(ex) =
    res = Map.get("examples/{ex.name}/compile", ex.srcs) ?
      error("missing compilation instr. for {ex.name}")
    d = Resource.export_data(res) ? error("missing compilation resource for {ex.name}")
    d.data

  pack(ex) =
    Map.get("examples/{ex.name}/pack.zip", ex.srcs) ?
      error("missing zip package for {ex.name}")

  exe(e) = "examples/{e.name}/{e.name}.exe"

  compile(e) =
    execute("cd examples/{e.name} && bash compile")

  rerun(e) =
    do execute("(pgrep -f {exe(e)} | grep -v $$ | xargs kill) || true")
    do execute_parallel("{exe(e)} --port {e.port} --db-force-upgrade")
    void

  check(e) =
    _ = compilation_instructions(e)
    _ = pack(e)
    void

  deploy(recompile, e) : void =
    do Log.info("HOP", "Deploying <{e.name}>")
    do check(e)
    do
      if recompile then
        compile(e)
      else
        void
    do rerun(e)
    void

  deploy_all(ex, recompile) =
    do List.iter(deploy(recompile, _), ex)
    if recompile then
      System.exit(0)
    else
      void

}}
