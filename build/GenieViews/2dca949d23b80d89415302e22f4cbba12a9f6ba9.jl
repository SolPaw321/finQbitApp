# app\resources\users\views\index.jl.html 

function func_2dca949d23b80d89415302e22f4cbba12a9f6ba9(;
    context = Genie.Renderer.vars(:context),
    users = Genie.Renderer.vars(:users),
)

    [
        Genie.Renderer.Html.title(htmlsourceindent = "2") do
            [
                """Genie with Pluto""";
            ]
        end
        Genie.Renderer.Html.style(htmlsourceindent = "2") do
            [
                """
                      #notebook-list {
                          list-style-type: none;
                          padding: 0;
                      }
                      #notebook-list li {
                          cursor: pointer;
                          margin: 5px 0;
                      }
                      #notebook-list li:hover {
                          text-decoration: underline;
                      }
                  """
            ]
        end
        Genie.Renderer.Html.h1(htmlsourceindent = "2") do
            [
                """Welcome """
                users.name
            ]
        end
        Genie.Renderer.Html.br(htmlsourceindent = "2")
        Genie.Renderer.Html.button(onclick = "listNotebooks()", htmlsourceindent = "2") do
            [
                """List Notebooks""";
            ]
        end
        Genie.Renderer.Html.button(onclick = "newNotebook()", htmlsourceindent = "2") do
            [
                """Create new Notebook""";
            ]
        end
        Genie.Renderer.Html.button(
            onclick = "window.location.href='/logout'",
            htmlsourceindent = "2",
        ) do
            [
                """Log out""";
            ]
        end
        Genie.Renderer.Html.ul(htmlsourceindent = "2", id = "notebook-list")
        Genie.Renderer.Html.br(htmlsourceindent = "2")
        Genie.Renderer.Html.iframe(
            height = "800px",
            htmlsourceindent = "2",
            id = "dynamic_iframe",
            src = "http://localhost:1234/$(users.pluto_key)",
            style = "border:None;",
            width = "100%",
        )
        Genie.Renderer.Html.script(htmlsourceindent = "2") do
            [
                """
                    // Function to fetch the list of files and display them
                    function listNotebooks() {
                        fetch('/notebooks')
                            .then(response => response.json())
                            .then(data => {
                                const list = document.getElementById('notebook-list');
                                list.innerHTML = '';
                                data.forEach(name => {
                                    const li = document.createElement('li');
                                    const a = document.createElement('a');
                                    a.textContent = name;
                                    li.appendChild(a);
                                    li.textContent = name;
                                    // Create context menu
                                    const contextMenu = document.createElement('div');
                                    contextMenu.classList.add('context-menu');
                                    const openNotebook = document.createElement('a');
                                    openNotebook.textContent = 'Open Notebook ';
                                    openNotebook.onclick = () => _openNotebook(name);
                                    const downloadNotebook = document.createElement('a');
                                    downloadNotebook.textContent = 'Download Notebook ';   
                                    downloadNotebook.href = 'http://127.0.0.1:8000/notebooks/' + name;
                                    downloadNotebook.download = name;
                                    const deleteNotebook = document.createElement('a');
                                    deleteNotebook.textContent = 'Delete Notebook ';
                                    deleteNotebook.onclick = () => _deleteNotebook(name);
                                    contextMenu.appendChild(openNotebook);
                                    contextMenu.appendChild(downloadNotebook);
                                    contextMenu.appendChild(deleteNotebook);
                                    li.appendChild(contextMenu);
                                    // Show context menu on hover
                                    li.onmouseover = () => {
                                        contextMenu.style.display = 'block';
                                    };
                                    li.onmouseout = () => {
                                        contextMenu.style.display = 'none';
                                      };
                                    list.appendChild(li);
                                    });
                                })
                            .catch(error => {
                                console.error('Error fetching files:', error);
                            });
                    }
                    function _openNotebook(name){
                        const iframe = document.getElementById('dynamic_iframe');
                        const url = "http://localhost:1234/$(users.pluto_key)/open?path=notebooks/" + encodeURIComponent(name);
                        iframe.src = url
                    }
                    function _deleteNotebook(name){
                        if (confirm("Are you sure you want to delete " + name + "?")) {
                            fetch('/pluto/delete/' + name, {
                                method: 'DELETE'
                            })
                                .then(response => {
                                    if (response.status === 200) {
                                        alert('File deleted successfully.');
                                    } else if (response.status === 404) {
                                        alert('File not found.');
                                    } else {
                                        alert('Error deleting file.');
                                    }
                                })
                                .catch(error => console.error('Error:', error));
                        }
                    }
                    function newNotebook(name){
                        const iframe = document.getElementById('dynamic_iframe');
                        const url = "http://localhost:1234/$(users.pluto_key)/new"
                        iframe.src = url
                    }
                """
            ]
        end
    ]
end
