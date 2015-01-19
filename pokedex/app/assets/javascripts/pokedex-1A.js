Pokedex.RootView.prototype.addPokemonToList = function (pokemon) {
  var $li = $('<li data-id="' + pokemon.get('id') + '"></li>').addClass("poke-list-item");
  var name = pokemon.get('name');
  var poke_type = pokemon.get('poke_type');
  $li.html(name + " - " + poke_type + " type");
  this.$pokeList.append($li);
};

Pokedex.RootView.prototype.refreshPokemon = function (callback) {
  var rvclass = this;
  this.pokes.fetch({
    success: function () {
      var pokes = rvclass.pokes.models
      pokes.forEach( function (pokemon){
        rvclass.addPokemonToList(pokemon);
      })
    }
  });


};
