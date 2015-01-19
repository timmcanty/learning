Pokedex.RootView.prototype.addToyToList = function (toy) {
  var $toy = $('<li></li').html(toy.get('name') + ' -- ' + toy.get('price') + ' -- ' + toy.get('happiness'));
  $toy.data('toy-id', toy.get('id'));
  $toy.data('pokemon-id', toy.get('pokemon_id'));
  $toy.addClass('toy')
  $('.toys').append($toy);
};

Pokedex.RootView.prototype.renderToyDetail = function (toy) { // III
  var imageUrl = toy.get('image_url');

  this.$toyDetail.data('toyId', toy.escape('id'));
  this.$toyDetail.data('pokeId', toy.escape('pokemon_id'));

  this.$toyDetail.empty().append('<img src="' + imageUrl + '"></img>'
  );

  var $select = $('<select></select>').addClass("toy-switch");

  var pokes = this.pokes.models;
  for (var i = 0; i < pokes.length; i++) {
    var selected = "";
    if (pokes[i].escape('id') === toy.escape('pokemon_id')) {
      var selected = 'selected'
    }
    var $opt = $('<option ' + selected + '>' + pokes[i].escape('name') + '</option>');
    $opt.val(pokes[i].escape('id'));
    $select.append($opt);
  }
  this.$toyDetail.append($select);
};

Pokedex.RootView.prototype.selectToyFromList = function (event) {
  var $toy = $(event.currentTarget);
  var toyId = $toy.data('toyId');
  var pokemonId = $toy.data('pokemonId');
  var pokemon = this.pokes.get(pokemonId);
  var toy = pokemon.toys().get(toyId);
  this.renderToyDetail(toy);
};
