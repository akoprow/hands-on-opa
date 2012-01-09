import stdlib.apis.{facebook, facebook.auth, facebook.graph}
import stdlib.{themes.bootstrap, widgets.bootstrap}

config = OpaIntro1.config
redirect = "http://facebook-01.tutorials.opalang.org/connect"

FBA = FbAuth(config)
FBG = FbGraph

function main() {
  login_url = FBA.user_login_url([], redirect)
  <a href="{login_url}"><img src="resources/fb_connect.png" /></a>
}

function show_box(t, title, description) {
  WBootstrap.Message.make(
    { alert: ~{ title, description }
    , closable: false
    },
    t
  )
}

function get_name(token) {
  opts = { FBG.Read.default_object with token:token.token }
  match (FBG.Read.object("me", opts)) {
    case {~object}:
      match (List.assoc("name", object.data)) {
        case {some: {String: v}}: some(v)
        default: none
      }
    default: none
  }
}

function get_friends_ids(token) {
  opts = FBG.default_paging
  match (FBG.Read.connection("me", "friends", token.token, opts)) {
    case {success: c}:
       some(List.map(function (friend) { friend.id }, c.data))
    default: none
  }
}

function main_msg(friends) {
  function friend_img(id) {
    { href: none
    , onclick: ignore
    , content: <img src={FBG.Read.picture_url(id, {square})} />
    }
  }
  <>
    <h4>Your friends:</>
    {WBootstrap.Media.grid(List.map(friend_img, friends))}
  </>
}

function connect(data) {
  match (FBA.get_token_raw(data, redirect)) {
    case {~token}:
      match (get_name(token)) {
        case {some: name}:
          match (get_friends_ids(token)) {
            case {some: friends}:
              show_box({success}, "Hello, {name}!", main_msg(friends))
            default:
              show_box({error}, "Error getting your friends list", <></>)
          }
        default:
          show_box({error}, "Error getting your name", <></>)
      }
    case ~{error}:
      show_box({error}, error.error, <>{error.error_description}</>)
  }
}

function page(body) {
  Resource.html("Facebook connect tutorial",
    WBootstrap.Layout.fixed(
      <>
        <h1>Facebook connect tutorial</>
        {body}
      </>
    )
  )
}

dispatcher = parser
| "/connect?" data=(.*) -> connect(Text.to_string(data)) |> page
| .* -> main() |> page

Server.start(Server.http,
  [ { resources: @static_resource_directory("resources") }
  , { custom: dispatcher }
  ]
)
