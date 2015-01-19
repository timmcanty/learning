  $.UsersSearch = function (el) {
    this.$el = $(el);
    this.$users = $('.users');
    this.handleKeyPress();
  };

  $.UsersSearch.prototype.renderResults = function (data) {
    this.$users.empty();
    for (var i = 0; i < data.length; i++) {
      var $link = $('<a href="'+ data[i].id +'">'+ data[i].username + '</a>')
      var $toggleButton = $('<button class="follow-toggle"></button>');
      var $li = $('<li></li>');
      $li.append($link);
      $li.append($toggleButton);
      this.$users.append($li);
      $toggleButton.followToggle({
        userId: data[i].id,
        followState: (data[i].followed ? 'followed' : 'unfollowed'),
        url: "/users/" + data[i].id + "/follow"
      });
    }
  }

  $.UsersSearch.prototype.handleKeyPress = function () {
    var userSearch = this;
    var $el = this.$el;

    this.$el.on('keyup', function () {

      $.ajax( {
        type: 'GET',
        url: '/users/search',
        data: { "query" : $el.val() },
        dataType: 'JSON',
        success: function (data) {
          console.log(data);
          userSearch.renderResults(data);
        },
        error: function (data) {
          console.log(data);
          console.log("Search request failed");
        }
      })
    })
  }


$.fn.usersSearch = function () {
  return this.each(function () {
    new $.UsersSearch(this);
  });
};

$(function () {
  $(".searchtext").usersSearch();
});
