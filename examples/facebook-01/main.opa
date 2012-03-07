 // Importing Facebook APIs
import stdlib.apis.{facebook, facebook.auth, facebook.graph}
 // as well as the Bootstrap theme and system library
import stdlib.{themes.bootstrap, system}

 // A page to which Facebook will re-direct us upon successful authentication
redirect = "http://facebook-01.tutorials.opalang.org/connect"

 /* We store Facebook application configuration in the database. It contains
    secret keys that should not be shared with the world so if we were to store
    it as plain text in the code itself that would mean we could not easily
    share that code */
database Facebook.config /facebook_config

 /* We need a way to initialize the /facebook_config data. We do that via
    command line arguments. Running the application for the first time one
    should provide the "--fb-config APP_ID, APP_SECRET" argument with applications
    key and secret. */
fb_cmd_args =
  { init: void,
    parsers: [{ CommandLine.default_parser with
      names: ["--fb-config"],
      param_doc: "APP_ID,APP_SECRET",
      description: "Sets the application ID for the associated Facebook application",
      function on_param(state) {
        parser {
        case app_id=Rule.alphanum_string [,] app_secret=Rule.alphanum_string:
          /facebook_config <- {~app_id, api_key: app_id, ~app_secret};
          {no_params: state}
        }
      }
    }],
    anonymous: [],
    title: "Facebook configuration"
  }

 // We process the family of command line arguments for Facebook configuration
CommandLine.filter(fb_cmd_args)

 // We try to read Facebook configuration from the database
server config =
  match (?/facebook_config) {
  case {some: config}: config
  default:
     // In case we fail, we display an error message
    Log.error("webshell[config]", "Cannot read Facebook configuration (application id and/or secret key)
Please re-run your application with: --fb-config option")
     // ... and quite
    System.exit(1)
  }

 // We initialize Facebook authentication module with our app's configuration
FBA = FbAuth(config)
FBG = FbGraph

 // The main screen
function main() {
  login_url = FBA.user_login_url([], redirect)
   // Just shows Facebook connect button linking to the URL obtained from the
   // Facebook authentication module
  <a href="{login_url}">
    <img src="resources/fb_connect.png" />
  </a>
}

 /* Auxiliary UI function that just shows a box of a given [box_type] with a given
    [title] and [description]. We use Bootstrap Alerts markup for that. */
function show_box(box_type, title, description) {
  <div class="alert alert-{box_type}">
    <h4>{title}</>
    {description}
  </>
}

 /* Auxiliary function for processing JSON data obtained from Facebook Graph
    API. Gets an [obj]ect and tries to extract field named [field] */
function extract_field(obj, field) {
  match (List.assoc(field, obj.data)) {
    case {some: {String: v}}: some(v)
    default: none
  }
}

 /* Returns the name of the currently authenticated Facebook user */
function get_name(token) {
  opts = { FBG.Read.default_object with token:token.token }
  match (FBG.Read.object("me", opts)) {
  case {~object}: extract_field(object, "name")
  default: none
  }
}

 /* Returns a list of friends of the currently logged in Facebook user.
    The records have two fields: [id] and [name], with respectively the ID and
    name of every friend. */
function get_friends_ids(token) {
  match (FBG.Read.connection("me", "friends", token.token, FBG.default_paging)) {
  case {success: c}:
    function get_friend(data) {
      id = data.id
      name = extract_field(data, "name") ? ""
      ~{id, name}
    }
    some(List.map(get_friend, c.data))
  default: none
  }
}

/* Shows a grid with thumbnails of all friends of the currently logged in user,
 and their names as titles of the IMGes (will show on hover in most browsers) */
function show_friends(friends) {
  function friend_thumb(friend) {
      <li>
        <a href="#" class="thumbnail">
          <img src={FBG.Read.picture_url(friend.id, {square})} title={friend.name}/>
        </>
      </>
  }
  <ul class="thumbnails">
    {List.map(friend_thumb, friends)}
  </>
}

/* Facebook callback, that tries to authenticate the user */
function connect(data) {
  match (FBA.get_token_raw(data, redirect)) {
  case {~token}:
    match (get_name(token)) {
    case {some: name}:
      match (get_friends_ids(token)) {
      case {some: friends}:
        show_box("success", "Hello, {name}! This is the list of your friends:", show_friends(friends))
      default:
        show_box("error", "Error getting your friends list", <></>)
      }
    default:
      show_box("error", "Error getting your name", <></>)
    }
  case ~{error}:
    show_box("error", error.error, <>{error.error_description}</>)
  }
}

/* Basic page wrapper */
function page(body) {
  Resource.html("Facebook connect tutorial",
    <div class=container>
      <h1>Facebook connect tutorial</>
      {body}
    </>
  )
}

/* URL dispatcher. Handles Facebook redirection URL. */
dispatcher = parser {
case "/connect?" data=(.*) -> connect(Text.to_string(data)) |> page
case .* -> main() |> page
}

/* The main server, registers resources and dispatches URL with [dispatcher] */
Server.start(Server.http,
             [ { resources: @static_resource_directory("resources") },
               { custom: dispatcher } ]
            )
