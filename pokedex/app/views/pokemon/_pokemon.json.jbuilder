json.(pokemon, :id, :attack, :defense, :image_url, :moves, :name, :poke_type)


  json.toys do #namespace occurs at top level
    json.array!(pokemon.toys) do |toy| #to treat as array of JSON objects, this is necessary with template
      json.partial!("./toys/toy", toy: toy)
    end
  end
