defmodule InteramedWeb.MedicinesController do
  use InteramedWeb, :controller

  alias Interamed.MedicinesList

  action_fallback InteramedWeb.FallbackController

  def get_medicines(conn, %{"search" => text_search}) do
    {:ok, res: res} = MedicinesList.get_medicines(text_search)

    conn
    |> put_status(200)
    |> render("interactions.json", interactions: res)
  end

  def interactions(conn, %{"medicines" => medicines}) do
    {:ok, res: res} = MedicinesList.interactions(medicines)

    conn
    |> put_status(200)
    |> render("interactions.json", interactions: res)
  end
end
