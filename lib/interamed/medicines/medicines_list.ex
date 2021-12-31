defmodule Interamed.MedicinesList do
  @collection "medicines"
  # db.medicines.find({"_id" : ObjectId("6176e303f6a47a1848f67821"),"interacao": { $in:[/zoledrônico/]}}).pretty().count()

  #  db.medicines.find({"nomeComercial": {$in: [/dipirona/]}, "interacao": {$in:[/ácido acetilsalicílico/]}}).pretty()
  #  "6176bf83f6a47a18483e5cd6" -> Dipirona
  # "6176a3bbf6a47a18483b777d" -> ácido acetilsalicílico

  def get_medicines(text_search) do
    search_expression = %BSON.Regex{pattern: text_search, options: "i"}

    search_result =
      Mongo.find(
        :database,
        @collection,
        %{
          "$or" => [
            %{"principioAtivo" => %{"$in" => [search_expression]}},
            %{"nomeComercial" => %{"$in" => [search_expression]}}
          ]
        },
        limit: 10
      )
      |> Enum.to_list()

    {:ok, res: search_result}
  end

  def interactions(medicines) do
    ids = Enum.map(medicines, fn id_medicine -> objectid(id_medicine) end)

    [hd, tail] =
      Mongo.find(:database, @collection, %{_id: %{"$in" => ids}})
      |> Enum.to_list()

    {:ok, res: [check_head([hd, tail]), check_head([tail, hd])]}
  end

  def check_head([
        %{"_id" => id} = main_interactive,
        %{"_id" => id_comparative, "principioAtivo" => principioAtivo}
      ]) do
    expressions =
      Enum.map(principioAtivo, fn pricipio -> %BSON.Regex{pattern: pricipio, options: "i"} end)

    case Mongo.find_one(:database, @collection, %{
           _id: id,
           interacao: %{"$in" => expressions},
           principioAtivo: %{"$nin" => expressions}
         }) do
      %{"_id" => _} = interaction ->
        interaction
        |> Map.put("idInteracao", id_comparative)
        |> Map.put("pricipiosComparados", principioAtivo)
        |> Map.put("intercao", true)

      _ ->
        main_interactive
        |> Map.put("idInteracao", id_comparative)
        |> Map.put("pricipiosInterativos", principioAtivo)
        |> Map.put("intercao", false)
    end
  end

  def objectid(id) do
    {_, idbin} = Base.decode16(id, case: :mixed)
    %BSON.ObjectId{value: idbin}
  end
end
