import stdlib.apis.{facebook, facebook.auth, facebook.graph}
import stdlib.{themes.bootstrap, widgets.bootstrap}

config = OpaIntro1.config
redirect = "http://facebook-01.tutorials.opalang.org/connect"

FBA = FbAuth(config)
FBG = FbGraph

function main() {
  login_url = FBA.user_login_url([], redirect)
  <a href="{login_url}">Just connect</a>
}

function show_error(err) {
  WBootstrap.Message.make(
    { alert: { title: err.error
             , description: <>err.error_description</>
             }
    , closable: false
    },
    {warning}
  )
}

function get_fb_data(id, object) {
  match (List.assoc(id, object.data)) {
    case {some: {String: v}}: some(v)
    default: none
  }
}

function get_name(token) {
  opts = { FBG.Read.default_object with token:token.token }
  match (FBG.Read.object("me", opts)) {
    case {~object}: get_fb_data("name", object)
    default: none
  }
}

function connect(data) {
  match (FBA.get_token_raw(data, redirect)) {
    case {~token}:
      match (get_name(token)) {
        case {some: name}:
          <h1>Hello, {name}!</>
        default:
          show_error({ error: "Problem getting user data"
                     , error_description: ""
                     })
      }
    case {~error}:
      show_error(error)
  }
}

function page(body) {
  Resource.html("Facebook connect tutorial",
    WBootstrap.Layout.fixed(body)
  )
}

dispatcher = parser
| "/connect?" data=(.*) -> connect(Text.to_string(data)) |> page
| .* -> main() |> page

Server.start(Server.http, { custom: dispatcher })
