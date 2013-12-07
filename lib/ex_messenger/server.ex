# Inspiration / blatant porting from: github.com/luisgabriel/erl-chat-server

defmodule ExMessenger.Server do
  use GenServer.Behaviour

  def start_link([]) do
    :gen_server.start_link({ :local, :message_server }, __MODULE__, [], [])
  end

  def init([]) do
    users = HashDict.new()
    { :ok, users }
  end

  def handle_call({:connect, nick}, {pid, _}, users) do
    cond do
      nick == :server or nick == "server" ->
        {:reply, :nick_not_allowed, users}
      users |> HashDict.has_key? nick ->
        {:reply, :nick_in_use, users}
      true ->
        newusers = users |> HashDict.put(nick, node(pid))
        userlist = newusers |> HashDict.keys |> Enum.join ":"

        :gen_server.cast(:message_server, {:say, :server, "**#{nick} has joined**\n"})
        {:reply, {:ok, userlist}, newusers}
    end
  end

  def handle_call({:disconnect, nick}, {pid, _}, users) do
    user = users |> HashDict.get(nick)

    cond do
      user == nil ->
        {:reply, :user_not_found, users}
      user == node(pid) ->
        newusers = users |> HashDict.delete nick

        :gen_server.cast(:message_server, {:say, :server, "**#{nick} has left**\n"})
        {:reply, :ok, newusers}
      true ->
        {:reply, :not_allowed, users}
    end
  end

  def handle_call(_, _, users), do: {:reply, :error, users}

  def handle_cast({:say, nick, msg}, users) do
    users |> broadcast "#{nick}: #{msg}\n"
    {:noreply, users}
  end

  def handle_cast({:private_message, nick, receiver, msg}, users) do
    case users |> HashDict.get receiver do
      nil -> :ok
      r -> :ok #send a message to another node? maybe to a gen server running on client.
    end
    {:noreply, users}
  end

  def handle_cast(_, users), do: {:noreply, users}

  ### Internal functions
  defp broadcast(users, msg) do
    users |> Enum.map(fn { nick, node } -> IO.inspect {nick, node} end)
  end
end