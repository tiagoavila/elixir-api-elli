defmodule RinhaBackend.EtsCache do
  use GenServer

  @table_name :nickname_cache

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_) do
    :ets.new(@table_name, [
      :set,
      :public,
      :named_table
    ])

    {:ok, nil}
  end

  def insert(nickname, person), do: :ets.insert(@table_name, {nickname, person})

  def exists?(nickname), do: :ets.member(@table_name, nickname)
end
