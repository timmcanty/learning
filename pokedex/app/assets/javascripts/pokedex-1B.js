Pokedex.RootView.prototype.renderPokemonDetail = function (pokemon) {
  this.$pokeDetail.empty();
  var $props = $('<article></article>').addClass("detail");
  var $imgTag = $('<img src="' + pokemon.get("image_url") + '"></img>');
  $props.append($imgTag);
  var attrNames = [ "name", "poke_type", "attack", "defense", "moves"];
  var that = this;

  for (var i = 0; i < attrNames.length; i++) {
    $dl = $('<dl></dl>');
    var attrValue = pokemon.get(attrNames[i]);
    $dt = $('<dt>' + attrNames[i] + '</dt>');
    $dl.append($dt);

    if (attrNames === "moves") {
      for (var j = 0; j < attrValue.length; j++) {
        var $dd = $('<dd>' + attrValue[j] + '</dd>');
        $dl.append($dd);
      }
    } else {
      var $dd = $('<dd>' + attrValue + '</dd>');
      $dl.append($dd);
    }
    $props.append($dl);
  }

  $props.append('<ul class="toys"></ul>')
  this.$pokeDetail.append($props);
  pokemon.fetch({
    success: function (response) {
      that.renderToyList(pokemon);

    }
  });

};

Pokedex.RootView.prototype.selectPokemonFromList = function (event) {
};



// @pokemon = Pokemon.includes(:toys).all
// render json: @pokemon.to_json(include: :toys)
//
//
// @pokemon = Pokemon.includes(:toys).all
// render :index
//
// @pokemon.each do |p|
//   render p
//   p.toys.each do |toy|
//
//   end
//
// end
