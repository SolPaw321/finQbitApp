using Genie
using Genie.Router
using Genie.Renderer.Json
using Genie.Renderer.Html
using HTTP
using FileIO
using Pluto

# import UUIDs: UUID, uuid1
import Pluto.Configuration
import Pluto.ServerSession
import Pluto.SessionActions
import Pluto.Notebook

using finQbitApp.AdminController
using finQbitApp.UsersController

route("/admin", AdminController.index, named = :get_home)
route("/user", UsersController.index, named = :get_home)

const NOTEBOOK_DIR = "notebooks/"

# Ensure the notebook directory exists
isdir(NOTEBOOK_DIR) || mkdir(NOTEBOOK_DIR)

# Route to list all notebooks
route("/notebooks", method = GET) do
  notebooks = readdir(NOTEBOOK_DIR)
  json(notebooks)
end

function notebook_path(notebook_name)
  joinpath(NOTEBOOK_DIR, notebook_name)
end

route("/pluto/delete/:name", method = DELETE) do
  name = params(:name)
  println("Name from params: $name")

  # Construct the full path to the file
  filepath = notebook_path(name)
  println("Constructed file path: $filepath")

  if isfile(filepath)
    println("File exists, preparing to delete: $filepath")
    rm(filepath)
    return "File deleted successfully."
  else
    println("File not found: $filepath")
    return "File not found."
  end
end

route("/") do
  html_file = joinpath(dirname(Base.current_project()), "public", "index.html")
  Genie.Renderer.Html.html(read(html_file, String))
end