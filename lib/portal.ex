defmodule Portal do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Portal.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defstruct [:left, :right]
  @doc """
  starts transfering `data` from `left` to `right`
  """

  def transfer(left, right, data) do
    # first add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end

    # returns a porta struct we will use next
    %Portal{left: left, right: right}
  end

  def push_right(portal) do
    # see if we can pop data from left. If so, push
    # the popped data to the right. Otherwise, do nothing.
    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(portal.right, h)
    end

    # let's return the portal itself
    portal
  end
end
