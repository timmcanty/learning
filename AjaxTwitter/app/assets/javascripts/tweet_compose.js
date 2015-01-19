$.TweetCompose = function (el) {
  this.$el = $(el);
  this.handleSubmit();
};


$.TweetCompose.prototype.handleSubmit = function () {

  var that = this;
  this.$el.on("submit", function (event) {
    event.preventDefault();
    that.submit();
  });

  this.$el.find('textarea').on("keyup", function (event) {
    var currentText = that.$el.find('textarea').val();
    that.$el.find('.chars-left').html('Characters left: ' + (140 - currentText.length));
  });

  this.$el.find('.add-mentioned-user').on("click", function (event) {
    that.addMentionedUser();
  });

  this.$el.on("click", "a.remove-mentioned-user", function (event) {
    $(event.currentTarget).parent().remove();
  })
};

$.TweetCompose.prototype.addMentionedUser = function () {
  var selector = $('.add-mentioned-script').html();
  this.$el.find('.mentioned-users').append(selector);
};

$.TweetCompose.prototype.removeMentionedUser = function () {

};

$.TweetCompose.prototype.handleSuccess = function (data) {
  var $tweet = $('<li> ' + JSON.stringify(data) + '</li>');
  var feed = this.$el.data('tweets-ul')
  this.clearInput();
  this.$el.find(':input').prop('disabled',false);
  $(feed).prepend($tweet);
};



$.TweetCompose.prototype.clearInput = function () {
  $(this.$el.find('option')[0]).attr("selected","selected")
  this.$el.find('textarea').val('');
  $('.mentioned-users').empty();
};

$.TweetCompose.prototype.submit = function () {
  var that = this;
  var $el = this.$el;
  var formData = $el.serializeJSON();

  $el.find(':input').prop('disabled',true);

  $.ajax( {
    type: 'POST',
    url: "/tweets",
    data: formData,
    dataType: 'JSON',
    success: function (data) {
      that.handleSuccess(data);
    },
    fail: function (data) {
      console.log('failed');
    }
  })
};


$.fn.tweetCompose = function () {
  return this.each(function () {
    new $.TweetCompose(this);
  });
};


$(function () {
  $(".tweet-compose").append('<label Content </label>')
  $(".tweet-compose").tweetCompose();
});
