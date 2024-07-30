module PlutoController
  
import Pluto.Configuration, Pluto.ServerSession, Pluto.SessionActions, Pluto.Notebook
using FileIO, Pluto
using Base: run, kill, Process
using finQbitApp.Users
using SearchLight

export PlutoProcess
export ProcessDict

struct PlutoProcess
  pid::Int
  pluto_key::String
  pluto_process::Process
end

ProcessDict::Dict = Dict{DbId, Int}() #user.id => pid



function PlutoProcess(user::User) # Starting Pluto Server
  try
    julia_cmd = `julia -e "using Pluto; import Pluto.ServerSession; session = ServerSession(); session.options.server.port = 1234; session.options.server.base_url = \"/$(user.pluto_key)/\"; session.options.server.launch_browser=false; session.options.security.require_secret_for_open_links=false; session.options.security.require_secret_for_access = false; Pluto.run(session)"`
    process = run((Cmd(julia_cmd, dir="./notebooks/$(user.id)")), wait=false)
    println("Pluto has started")
    pid = getpid(process)
    println("Pluto should start at: https://localhost:1234/$(user.pluto_key)/")
    typeof(user.id)
    push!(ProcessDict, user.id => pid)
    return PlutoProcess(pid, user.pluto_key, process)

  catch e
    println("Error occured:", e)
  end
end

function end_session(plutoprocess::PlutoProcess)
  kill(plutoprocess.pluto_process)
end

function create()
end

function read()
end

function edit()
end

function update()
end

function delete()
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

function download()
end

function upload()
end


end
