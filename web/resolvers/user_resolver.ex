defmodule AbsintheTut.Resolvers.UserResolver do
  alias AbsintheTut.{User, Repo}

  def all(_args, _info) do
    {:ok, Repo.all(User)}
  end

  def find(%{id: id}, _info) do
    case Repo.get(User, id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def update(%{id: id, user: user_params}, _info) do
    User
    |> Repo.get!(id)
    |> User.update_changeset(user_params)
    |> Repo.update()
  end

  def login(params, _info) do
    with {:ok, user} <- AbsintheTut.Session.authenticate(params, Repo),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user, :access)
    do
      {:ok, %{token: jwt}}
    end
  end
end
