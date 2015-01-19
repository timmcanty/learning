Pokedex.Router = Backbone.Router.extend({
  routes: {
    '' : 'pokemonIndex',
    'pokemon/:id' : 'pokemonDetail',
    'pokemon/:pokemonId/toys/:toyId' : 'toyDetail'
  },

  pokemonDetail: function (id, callback) {
    if (this._pokemonIndex) {
      var pokemon = this._pokemonIndex.pokes.get(id);
      this._pokemonDetail = new Pokedex.Views.PokemonDetail({model: pokemon});
      $("#pokedex .pokemon-detail").html(this._pokemonDetail.$el);
      this._pokemonDetail.refreshPokemon();
    } else {
      this.pokemonIndex(function () {
        this.pokemonDetail(id);
      }.bind(this));
    }
    callback && callback();
  },

  pokemonIndex: function (callback) {
    this._pokemonIndex = new Pokedex.Views.PokemonIndex();
    if (callback) {
      this._pokemonIndex.refreshPokemon(callback);
    } else {
      this._pokemonIndex.refreshPokemon();
    }
    $("#pokedex .pokemon-list").html(this._pokemonIndex.$el);
    this.pokemonForm();
  },

  toyDetail: function (pokemonId, toyId) {
    if (this._pokemonDetail) {
      var pokemon = this._pokemonDetail.model;
      var toy = pokemon.toys().get(toyId);
      this._toyDetail = new Pokedex.Views.ToyDetail({model: toy});
      $("#pokedex .toy-detail").html(this._toyDetail.$el);
      this._toyDetail.render();
    } else {
      this.pokemonDetail(pokemonId, function () {
        this.toyDetail(pokemonId, toyId)
      }.bind(this));
    }
  },

  pokemonForm: function () {
    var newPokemon = new Pokedex.Models.Pokemon();
    this._pokemonForm = new Pokedex.Views.PokemonForm({newPokemon: newPokemon, pokes: this._pokemonIndex.pokes});
    $("#pokedex .pokemon-form").html(this._pokemonForm.render().$el);
    console.log(this._pokemonForm.$el);
  }
});


$(function () {
  new Pokedex.Router();
  Backbone.history.start();
});
