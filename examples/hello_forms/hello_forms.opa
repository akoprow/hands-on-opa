import stdlib.themes.bootstrap
import stdlib.widgets.formbuilder
import stdlib.web.mail

type gender = {male} / {female}

FB = WFormBuilder

@stringifier(gender) gender_to_string =
| {male} -> "male"
| {female} -> "female"

@xmlizer(gender) gender_to_xhtml(gender) = <>{"{gender}"}</>

registration_form() =
  user_name_validator(input) =
    rec name_ok = parser
    | {Rule.eos} -> true
    | [a-zA-Z0-9_\-.] ok=name_ok -> ok
    | .* -> false
    if Parser.parse(name_ok, input) then
      {success=input}
    else
      {failure = <>The user-name can only contain letters, digits and [_-.].</>}
  reg_form = FB.mk_form()
  fld_username =
       FB.mk_field("Username", FB.text_field)
    |> FB.make_required(_, <>Please enter your username</>)
    |> FB.add_validator(_, user_name_validator)
    |> FB.add_hint(_, <>This will be your short identificator in the system. The user-name can only contain letters, digits, underscore (_), hyphen (-) and dot (.) characters.</>)
  fld_email =
       FB.mk_field("Email Address",
         FB.email_field(<>This is not a correct email</>)
       )
    |> FB.make_required(_, <>Please enter a valid email address</>)
    |> FB.add_hint(_, <>You need to provide a <b>valid</b> email address, as it will be used to send you an invitation to the system. It will also be used for communication with you, updated, notifications...</>)
  fld_passwd =
       FB.mk_field("Password", FB.passwd_field)
    |> FB.make_required(_, <>Please enter your password</>)
    |> FB.add_validator(_, FB.password_validator(FB.empty_passwd_validator_spec))
    |> FB.add_hint(_, <>Please provide a password that will be used to authenticate you in the service. <b>Keep it safe!</b> The password will need to be at least 6 characters long and should contain at least one digit.</>)
  fld_passwd2 =
       FB.mk_field("Password (again)", FB.passwd_field)
    |> FB.make_required(_, <>Please repeat your password</>)
    |> FB.add_validator(_, FB.equals_validator(fld_passwd, <>Your passwords don't match</>))
    |> FB.add_hint(_, <>Well, you know; just to make sure you can ;)</>)
  fld_homepage =
       FB.mk_field("Your homepage", FB.uri_field(<>This is not a correct URL</>))
    |> FB.add_hint(_, <>Please provide an address of your homepage.</>)
  fld_desc =
       FB.mk_field("Description", FB.desc_field)
    |> FB.add_hint(_, <>Why not telling us a bit about yourself?.</>)
  fld_sex =
       FB.mk_field("Gender",
         FB.select_combobox_field([{male}, {female}], gender_to_string,
           gender_to_xhtml, <>Please select a value</>)
       )
  submit_form(data) =
    show_with(fld, render) =
      match FB.get_field_value(fld) with
      | {none} -> <>---</>
      | {some=value} -> <>{render(value)}</>
    show(fld) = show_with(fld, (v -> <>{v}</>))
    res =
      <div class="alert-message block-message">
        <h3>Form submitted:</>
        <strong>Username:</> {show(fld_username)}<br/>
        <strong>Email address:</> {show_with(fld_email, (e -> <>{e : Email.email}</>))}<br/>
        <strong>Password:</> {show(fld_passwd)}<br/>
        <strong>Homepage:</> {show_with(fld_homepage, (u -> <>{u : Uri.uri}</>))}<br/>
        <strong>Description:</> {show(fld_desc)}<br/>
        <strong>Gender:</> {show_with(fld_sex, (v -> <>{v : gender}</>))}
      </>
    Dom.transform([#result <- res])
  render_fld = FB.render_field(reg_form, _)
  submit = <button class="btn primary" onclick={FB.submit_action(reg_form)}>Submit</>
  form_body =
    <div class="container">
      {render_fld(fld_username)}
      {render_fld(fld_email)}
      {render_fld(fld_passwd)}
      {render_fld(fld_passwd2)}
      {render_fld(fld_homepage)}
      {render_fld(fld_desc)}
      {render_fld(fld_sex)}
      {submit}
      <span id=#result />
    </>
  FB.render_form(reg_form, form_body, submit_form)

server = one_page_server("Registration form", registration_form)
