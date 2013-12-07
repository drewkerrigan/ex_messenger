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

        IO.puts "#{nick} joined, userlist: #{userlist}"

        :gen_server.cast(:message_server, {:say, :server, "**#{nick} has joined**"})
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
        userlist = newusers |> HashDict.keys |> Enum.join ":"

        IO.puts "#{nick} left, userlist: #{userlist}"

        :gen_server.cast(:message_server, {:say, :server, "**#{nick} has left**"})
        {:reply, :ok, newusers}
      true ->
        {:reply, :not_allowed, users}
    end
  end

  def handle_call(_, _, users), do: {:reply, :error, users}

  def handle_cast({:say, nick, msg}, users) do
    ears = HashDict.delete(users, nick)

    IO.puts "#{nick} said #{msg}"

    broadcast(ears, nick, "#{msg}")

    {:noreply, users}
  end

  def handle_cast({:private_message, nick, receiver, msg}, users) do
    case users |> HashDict.get receiver do
      nil -> :ok
      r ->
        :gen_server.cast({:message_handler, r}, {:message, nick, "(#{msg})"})
    end
    {:noreply, users}
  end

  def handle_cast(_, users), do: {:noreply, users}

  ### Internal functions
  defp broadcast(users, from, msg) do
    Enum.each(users, fn { _, node } -> :gen_server.cast({:message_handler, node}, {:message, from, msg}) end)
  end
end