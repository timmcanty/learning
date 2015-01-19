Pokedex.Views = {}

Pokedex.Views.PokemonIndex = Backbone.View.extend({
  events: {
    'click .poke-list-item' : 'selectPokemonFromList'
  },

  initialize: function () {
    this.pokes = new Pokedex.Collections.Pokemon();
  },

  addPokemonToList: function (pokemon) {
    var content = JST['pokemonListItem']({pokemon: pokemon});
    this.$el.append(content);
  },

  // function (options) {}
  refreshPokemon: function (callback) {
    this.pokes.fetch({
      success: (function () {
        this.render();
        callback && callback();
      }).bind(this)
    });

    return this.pokes;
  },

  render: function () {
    this.$el.find('ul.pokemon-list').empty();
    this.pokes.each(function (pokemon) {
      this.addPokemonToList(pokemon)
    }.bind(this));
  },

  selectPokemonFromList: function (event) {
    var pokemonId = $(event.target).data('id');
    var pokemon = this.pokes.get(pokemonId);
    Backbone.history.navigate('/pokemon/' + pokemonId, {trigger: true})

  }
});

Pokedex.Views.PokemonDetail = Backbone.View.extend({
  events: {
    "click li.toy-list-item": "selectToyFromList"
  },

  refreshPokemon: function (options) {
    this.model.fetch({
      success: function () {
        this.render();
      }.bind(this)
    });
  },

  render: function () {
    this.$el.empty();
    var content = JST['pokemonDetail']({pokemon: this.model});
    this.$el.html(content);
    this.model.toys().forEach( function (toy) {
      var content = JST['toyListItem']({toy: toy});
      this.$el.append(content);
    }.bind(this));
  },

  selectToyFromList: function (event) {
    var toyId = $(event.currentTarget).data('id');
    var toyPokemonId = $(event.currentTarget).data('pokemon-id');
    Backbone.history.navigate('/pokemon/' + toyPokemonId + '/toys/' + toyId, {trigger: true});



    // var toy = this.model.toys().get(toyId);
    // var toyDetailView = new Pokedex.Views.ToyDetail({model: toy});
    // $("#pokedex .toy-detail").html(toyDetailView.$el);
    // toyDetailView.render();
  }
});

Pokedex.Views.ToyDetail = Backbone.View.extend({
  render: function () {
    console.log(this.model);
    var content = JST['toyDetail']({toy: this.model, pokes: []});
    this.$el.html(content);
  }
});



// $(function () {
//   var pokemonIndex = new Pokedex.Views.PokemonIndex();
//   pokemonIndex.refreshPokemon();
//   $("#pokedex .pokemon-list").html(pokemonIndex.$el);
// });
