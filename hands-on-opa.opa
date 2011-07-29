resources = @static_resource_directory("resources")

show_example(ex) =
  header =
    <div id=#title>
      {ex.name}
    </>
    <div id=#post>
      <a href={ex.article.post} target="_blank">
        {ex.article.title}
      </>
    </>
    <a id=#logo href="/">
      <img src="/resources/img/hands-on-opa.png" />
    </>
    <a id=#opalang href="http://opalang.org">
      Go to opalang.org
    </>
    <div id=#src_code>
      <a href="https://github.com/akoprow/hands-on-opa/tree/master/{ex.name}">
        Source code
      </>
    </>
  page =
    <div id="header">{header}</div>
    <div id="container">
      <iframe src="http://94.23.204.210:{ex.port}" />
    </>
  Resource.styled_page("Hands on Opa: {ex.name}", ["/resources/style/style.css"], page)

urls =
  rec aux =
  | [] -> (parser {Rule.fail} -> @fail)
  | [x | xs] ->
    (parser
    | "/{x.name}" -> show_example(x)
    | res={aux(xs)} -> res
    )
  aux(examples)

server =
  do Examples.deploy_all(examples)
  Server.simple_bundle([resources], urls)
