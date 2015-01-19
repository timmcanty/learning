Pokedex.Views = (Pokedex.Views || {});

Pokedex.Views.PokemonForm = Backbone.View.extend({

  initialize: function (options) {
    this.newPokemon = options.newPokemon;
    this.pokes = options.pokes;
  },

  events: {
    'submit form': 'savePokemon'
  },

  render: function () {
    var content = JST['pokemonForm']({})
    this.$el.html(content);
    return this;
  },

  savePokemon: function (event) {
    event.preventDefault();
    var targetJSON = $(event.currentTarget).serializeJSON();
    var that = this;
    this.newPokemon.save(targetJSON['pokemon'], {
      success: function (model) {
        that.pokes.add(model);
        Backbone.history.navigate('pokemon/' + model.get('id'), {trigger: true});
      }
    })

  }
});
