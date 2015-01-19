Pokedex.RootView.prototype.createPokemon = function (attrs, callback) {
  var newPokemon = new Pokedex.Models.Pokemon(attrs);
  var that = this;
  newPokemon.save({}, { success: function () {
    // how is fetch working here
    newPokemon.fetch();
    that.pokes.add(newPokemon);
    that.addPokemonToList(newPokemon);
    callback(newPokemon);
  } });
}

Pokedex.RootView.prototype.submitPokemonForm = function (event) {
    var jsonForm = $(event.target).serializeJSON();
    this.createPokemon(jsonForm, this.renderPokemonDetail.bind(this));
};
