(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using finQbitApp
const UserApp = finQbitApp
finQbitApp.main()
