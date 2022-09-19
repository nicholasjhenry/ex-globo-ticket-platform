defmodule Emu.Store do
  @moduledoc """
  Supports the implementation of the Snapshot and Tombstone patterns.
  """

  alias Emu.Ticks
  alias GloboTicket.Repo

  def soft_delete(struct) do
    struct
    |> Ecto.build_assoc(:removed, removed_at: DateTime.utc_now())
    |> Repo.insert()
  end

  def save_entity_record(record) do
    Repo.insert(record, on_conflict: {:replace, [:uuid]}, conflict_target: [:uuid])
  end

  def save_snapshot(_entity, nil, next_snapshot) do
    Repo.insert(next_snapshot)
  end

  def save_snapshot(entity, record, assoc, field \\ :last_updated_ticks) do
    assoc_schema = record.__struct__.__schema__(:association, assoc).related

    last_snapshot = Map.fetch!(record, assoc) || struct(assoc_schema)
    struct = last_snapshot.__struct__
    next_snapshot = struct.from_entity(entity, record)

    if struct.equal?(last_snapshot, next_snapshot) do
      {:ok, last_snapshot}
    else
      entity
      |> Map.fetch!(field)
      |> concurrency_check!(last_snapshot)

      Repo.insert(next_snapshot)
    end
  end

  defp concurrency_check!(_timestamp, nil), do: :ok

  defp concurrency_check!(timestamp, last_snapshot) do
    updated_ticks = Ticks.from_date_time(last_snapshot.inserted_at)

    if Ticks.any?(timestamp) &&
         !Ticks.equal?(updated_ticks, timestamp) do
      raise Ecto.StaleEntryError, action: :insert, changeset: %{data: last_snapshot}
    else
      :ok
    end
  end
end
