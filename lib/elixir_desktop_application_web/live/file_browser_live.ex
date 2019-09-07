defmodule ElixirDesktopApplicationWeb.FileBrowserLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h3><%= @current %></h3>
    <ul>
      <li phx-click="cd" phx-value=".."><b>..</b></li>
      <%= for entry <- @dirs do %>
        <li phx-click="cd" phx-value="<%= entry %>"><b><%= entry %></b></li>
      <% end %>
      <%= for entry <- @files do %>
        <li><%= entry %></li>
      <% end %>
    </ul>
    """
  end

  def mount(_session, socket) do
    socket =
      socket
      |> assign(current: Path.expand("."))
      |> ls()

    {:ok, socket}
  end

  def handle_event("cd", param, socket) do
    socket =
      socket
      |> assign(current: path(socket, param))
      |> ls()

    {:noreply, socket}
  end

  defp ls(socket) do
    case File.ls(socket.assigns.current) do
      {:ok, entries} ->
        {dirs, files} = Enum.split_with(entries, &File.dir?(path(socket, &1)))

        assign(socket, dirs: Enum.sort(dirs), files: Enum.sort(files))

      _ ->
        socket
    end
  end

  defp path(socket, param) do
    Path.expand(socket.assigns.current <> "/" <> param)
  end
end
