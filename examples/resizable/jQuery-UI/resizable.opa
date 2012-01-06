package jquery.resizable

module Resizable {

  function mk_resizable(dom) {
    %%Resizable.mk_resizable%%(Dom.of_selection(dom))
  }

  server_components =
    [ { resources: @static_resource_directory("resources") }
    , { register: ["resources/jquery.ui.all.css", "resources/jquery.ui.base.css", "resources/jquery.ui.core.css", "resources/jquery.ui.resizable.css" ] }
    ]

}
