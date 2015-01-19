Pokedex.RootView.prototype.reassignToy = function (newPokeId, oldPokeId, toyId) {
  var that = this;
  var oldPokemon = this.pokes.get(oldPokeId);
  var toy = oldPokemon.toys().get(toyId);
  toy.set('pokemon_id', newPokeId);
  toy.save({}, {
    success: function () {
      oldPokemon.toys().remove(toy);
      that.renderToyList(oldPokemon);
      that.$toyDetail.empty();
    }
  });
};

Pokedex.RootView.prototype.renderToyList = function (pokemon) {
  var that = this;
  this.$pokeDetail.find(".toys").empty();
  pokemon.toys().models.forEach(  function (toy) {
    that.addToyToList(toy);
  });
}
