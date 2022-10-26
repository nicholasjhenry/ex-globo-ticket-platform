defmodule Emu.Store do
  @moduledoc """
  Supports the implementation of the Snapshot and Tombstone patterns.
  """

  alias Emu.Ticks

  def get_record!(query, repo, uuid) do
    repo.get_by!(query, uuid: uuid)
  end

  def soft_delete(struct, repo) do
    struct
    |> Ecto.build_assoc(:removed, removed_at: DateTime.utc_now())
    |> repo.insert()
  end

  def save_entity_record(repo, record) do
    repo.insert(record, on_conflict: {:replace, [:uuid]}, conflict_target: [:uuid])
  end

  def save_snapshot(repo, _entity, nil, next_snapshot) do
    repo.insert(next_snapshot)
  end

  def save_snapshot(repo, entity, record, assoc, field \\ :last_updated_ticks) do
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

      repo.insert(next_snapshot)
    end
  end

  defp concurrency_check!(_timestamp, nil), do: :ok

  defp concurrency_check!(timestamp, last_snapshot) do
    updated_ticks = Ticks.from_date_time(last_snapshot.inserted_at)

    if Ticks.any?(timestamp) && Ticks.compare(updated_ticks, timestamp) != :eq do
      raise Ecto.StaleEntryError, action: :insert, changeset: %{data: last_snapshot}
    else
      :ok
    end
  end
end
