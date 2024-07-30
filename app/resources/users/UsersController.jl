module UsersController
using GenieAuthentication, Genie.Renderer, Genie.Exceptions, Genie.Renderer.Html 
using finQbitApp.Users, finQbitApp.PlutoController
import SearchLight: findone


function index()
  authenticated!()
  current_user = findone(Users.User, id = get_authentication())
  #TODO start a pluto session on a given port and given user secret key
  if !in(current_user.id, keys(ProcessDict))
    println("Startinf PlutoProcess")
    pluto_process = PlutoController.PlutoProcess(current_user::User)
  else
    println("PlutoProcess is already running")
  end

  html(:users, :index, users = current_user)

end

end
