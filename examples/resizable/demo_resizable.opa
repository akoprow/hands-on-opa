import stdlib.{themes.bootstrap, widgets.bootstrap}
import jquery.resizable

WB = WBootstrap

function page() {
  msg =
    <div id=#msg class="alert-message warning"
         onready={function (_) { Resizable.mk_resizable(#msg) }}>
      <p><strong>Notice:</> this box is resizable; try dragging at its edges.</>
    </>
  WBootstrap.Layout.fixed(msg)
}

Server.start(Server.http,
  [ { resources: @static_resource_directory("resources") }
  , { register: [ "resources/jquery.ui.all.css"
                , "resources/jquery.ui.base.css"
                , "resources/jquery.ui.core.css"
                , "resources/jquery.ui.resizable.css"
                , "resources/style.css"
                ]
    }
  , {title: "jQuery-UI demo", ~page}
  ]
)
