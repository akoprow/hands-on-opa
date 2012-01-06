import stdlib.{themes.bootstrap, widgets.bootstrap}
import jquery.resizable

WB = WBootstrap

function page() {
  msg =
    <div id=#msg class="alert-message block-message warning"
      onready={function (_) { Resizable.mk_resizable(#msg) }}>
      <a class="close" href="#">×</>
      <p><strong>Holy guacamole! This is a warning!</> Best check yourself, you’re not looking too good.</>
      <div class="alert-actions">
        <a class="btn small" href="#">Take this action</> <a class="btn small" href="#">Or do this</>
      </>
    </>
  WBootstrap.Layout.fixed(msg)
}

Server.start(Server.http, {title: "jQuery-UI demo", ~page})
