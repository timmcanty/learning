window.Pokedex = (window.Pokedex || {});
window.Pokedex.Models = {};
window.Pokedex.Collections = {};

Pokedex.Models.Pokemon = Backbone.Model.extend({
  urlRoot: "/pokemon",

  toys: function () {
    if (!this._toys) {
      this._toys = new Pokedex.Collections.PokemonToys([]);
    }
    return this._toys;
  },

  parse: function (payload) {
    var that = this;
    if (payload.toys) {
      this.toys().set(payload.toys);
      delete payload.toys;
    }
    return payload;
  },

}); // WRITE ME

Pokedex.Models.Toy = Backbone.Model.extend({
  urlRoot: "/toys"
}); // WRITE ME IN PHASE 2

Pokedex.Collections.Pokemon = Backbone.Collection.extend({
  model: Pokedex.Models.Pokemon,
  url: "/pokemon"
}); // WRITE ME

Pokedex.Collections.PokemonToys = Backbone.Collection.extend({
  model: Pokedex.Models.Toy,
  url: "/toys"

}); // WRITE ME IN PHASE 2

window.Pokedex.Test = {
  testShow: function (id) {
    var pokemon = new Pokedex.Models.Pokemon({ id: id });
    pokemon.fetch({
      success: function () {
        console.log(pokemon.toJSON());
      }
    });
  },

  testIndex: function () {
    var pokemon = new Pokedex.Collections.Pokemon();
    pokemon.fetch({
      success: function () {
        console.log(pokemon.toJSON());
      }
    });
  }
};

window.Pokedex.RootView = function ($el) {
  var that = this;
  this.$el = $el;
  this.pokes = new Pokedex.Collections.Pokemon();
  this.$pokeList = this.$el.find('.pokemon-list');
  this.$pokeDetail = this.$el.find('.pokemon-detail');
  this.$newPoke = this.$el.find('.new-pokemon');
  this.$toyDetail = this.$el.find('.toy-detail');

  // Click handlers go here.
  this.$pokeList.on('click', '.poke-list-item', function (event) {
    //the below logic should go into pokedex-1B
    var id = $(this).data('id');
    var pokemon = that.pokes.get(id);
    that.renderPokemonDetail(pokemon);
  })

  this.$el.find('.new-pokemon').on('submit', function (event) {
    event.preventDefault();
    that.submitPokemonForm(event);
  })

  this.$pokeDetail.on('click', '.toy', function (event) {
    that.selectToyFromList(event);
  })

  this.$toyDetail.on('change', '.toy-switch', function (event) {
    var newPokeId = $(".toy-switch option:selected").val();
    var oldPokeId = that.$toyDetail.data('pokeId');
    var toyId = that.$toyDetail.data('toyId')
    that.reassignToy(newPokeId, oldPokeId, toyId);
  })

};

$(function() {
  var $rootEl = $('#pokedex');
	window.Pokedex.rootView = new Pokedex.RootView($rootEl);
  window.Pokedex.rootView.refreshPokemon();
});
