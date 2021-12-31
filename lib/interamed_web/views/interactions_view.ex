defmodule InteramedWeb.MedicinesView do
  def render("interactions.json", %{interactions: interactions}) do
    %{
      message: "Interações processadas com sucesso!",
      data: interactions
    }
  end
end
