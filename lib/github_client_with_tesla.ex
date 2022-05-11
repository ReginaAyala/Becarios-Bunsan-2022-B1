defmodule GitHub do
    # notice there is no `use Tesla`
  
    def user_repos(client, login) do
      # pass `client` argument to `Tesla.get` function
      Tesla.get(client, "/users/" <> login <> "/repos")
    end
  
    def issues(client) do
      Tesla.get(client, "/issues")
    end
  
    # build dynamic client based on runtime arguments
    def client(token) do
      middleware = [
        {Tesla.Middleware.BaseUrl, "https://api.github.com"},
        Tesla.Middleware.JSON,
        {Tesla.Middleware.Headers, [{"authorization", "token: " <> token }]}
      ]
      adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
      Tesla.client(middleware, adapter)
    end

    def get_repo(client, user_name, repo_name) do
      {:ok, response} = Tesla.get(client, "/repos/" <> user_name <> "/" <> repo_name)
      name_owner = response.body |> Map.get("owner") |> Map.get("login")

      {:ok, response} = Tesla.get(client, "/repos/" <> user_name <> "/" <> repo_name <> "/languages")
      language = response.body |> Enum.map(fn {k, _} -> k end)

      {:ok, response} = Tesla.get(client, "/repos/" <> user_name <> "/" <> repo_name <> "/commits") 
      num_commits = response.body |> length()
      
      %{"Name owner": name_owner,
        "language": language,
        "Num commits": num_commits}
      
    end
    
  end