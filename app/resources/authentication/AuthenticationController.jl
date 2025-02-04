module AuthenticationController

using Genie, Genie.Renderer, Genie.Renderer.Html
using SearchLight
using Logging

using ..Main.UserApp.Users
using ..Main.UserApp.GenieAuthenticationViewHelper

using GenieAuthentication
using GenieAuthentication.GenieSession
using GenieAuthentication.GenieSession.Flash
using GenieAuthentication.GenieSessionFileSession

using Random

function show_login()
  html(:authentication, :login, context = @__MODULE__)
end

function login()
  try
    user = findone(User, username = params(:username), password = Users.hash_password(params(:password)))
    authenticate(user.id, GenieSession.session(params()))

    redirect(:success)
  catch ex
    flash("Authentication failed! ")

    redirect(:show_login)
  end
end

function success()
  html(:authentication, :success, context = @__MODULE__)
end

function logout()
  deauthenticate(GenieSession.session(params()))

  flash("Good bye! ")

  redirect(:show_login)
end

function show_register()
  html(:authentication, :register, context = @__MODULE__)
end

function register()
  try
    pluto_key = randstring(9)
    user = User(username  = params(:username),
                password  = params(:password) |> Users.hash_password,
                name      = params(:name),
                email     = params(:email),
                pluto_key = pluto_key) |> save!

    authenticate(user.id, GenieSession.session(params()))
    mkdir(joinpath("notebooks", "$(user.id)"))

    html(:authentication, :register_redirect, context = @__MODULE__)
  catch ex
    @error ex

    if hasfield(typeof(ex), :msg)
      flash(ex.msg)
    else
      flash(string(ex))
    end

    redirect(:show_register)
  end
end

end