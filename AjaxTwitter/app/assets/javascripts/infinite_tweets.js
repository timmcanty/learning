$.InfiniteTweets = function (feed) {
  var that = this;
  this.maxCreatedAt = null ;
  this.$feed = $(feed);

  this.$feed.on('click', 'a.fetch-more', function () {
    that.fetchTweets();
  })
};

$.InfiniteTweets.prototype.fetchTweets = function () {
  var that = this;
  $.ajax( {
    type: 'GET',
    url: '/feed',
    dataType: 'JSON',
    data: (that.maxCreatedAt ? { "max_created_at" : that.maxCreatedAt } : ''),
    success: function (data) {
      that.successHandler(data);
    },
    fail: function (data) {
      console.log("fetchTweets request failed")
    }
  })
};

$.InfiniteTweets.prototype.successHandler = function (data) {
  if (data === []) {
    $('.fetch-more').remove();
    this.$feed.prepend('<p>Sorry, no more tweets,baby!</p>');
    return;
  } else if (data.length < 20) {
    $('.fetch-more').remove();
    this.$feed.prepend('<p>Sorry, no more tweets,baby!</p>');
  }
  this.maxCreatedAt = data[(data.length-1)].created_at;
  for (var i = 0; i < data.length; i++) {
    var tweet = $('<li></li>').append(JSON.stringify(data[i]));
    this.$feed.append(tweet);
  }
};



$.fn.infiniteTweets = function () {
  return this.each(function () {
    new $.InfiniteTweets(this);
  });
};

$(function () {
  $("#feed").infiniteTweets();
});
