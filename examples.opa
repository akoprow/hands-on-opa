type plugin =
  { name : string
  ; files : list(string)
  }

type example =
  { name : string
  ; port : int
  ; srcs : stringmap(Resource.resource)
  ; article : blog_article
  }

Examples = {{

  execute = %%Bash.execute%%
  execute_parallel = %%Bash.execute_parallel%%

  exe(e) = "examples/{e.name}/{e.name}.exe"

  compile(e) =
    execute("cd examples/{e.name} && bash compile")

  rerun(e) =
    do execute("(pgrep -f {exe(e)} | grep -v $$ | xargs kill) || true")
    do execute_parallel("{exe(e)} --port {e.port}")
    void

  deploy(e) : void =
    do Log.info("HOP", "Deploying <{e.name}>")
    do compile(e)
    do rerun(e)
    void

  deploy_all = List.iter(deploy, _)

}}
