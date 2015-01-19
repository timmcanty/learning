  $.FollowToggle = function (el, options) {
    this.$el = $(el);
    this.userId = this.$el.data("user-id") || options.userId;
    this.followState = this.$el.data("initial-follow-state") || options.followState;
    this.url = this.$el.data("url") || options.url;
    this.render();

    this.handleClick();


  };

  $.FollowToggle.prototype.handleClick = function () {
      console.log('in handle click');
      var that = this;
      this.$el.on('click', function (event) {
        event.preventDefault();
        if (that.followState === 'followed') {
          that.followState = 'unfollowing';
          that.render();
          that.unfollow();
        } else {
          that.followState = 'following';
          that.render();
          that.follow();
        }
      } )
  };

  $.FollowToggle.prototype.render = function () {
      console.log(this.followState);
      if (this.followState === 'followed') {
        this.$el.html("Unfollow");
        this.$el.prop('disabled', '');
      } else if (this.followState === 'unfollowed') {
        this.$el.html("Follow");
        this.$el.prop('disabled', '');
      } else {
        this.$el.html("...");
        this.$el.prop('disabled', true);
      }
  };

  $.FollowToggle.prototype.follow = function () {
    var that = this;
    $.ajax( {
      type: 'POST',
      url: that.url,
      dataType: 'JSON',
      success: function (data) {
        that.followState = 'followed';
        that.render();
      },
      fail: function (data) {
        console.log("Follow request failed")
      }
    })
  };

  $.FollowToggle.prototype.unfollow = function () {
    var that = this;
    $.ajax( {
      type: 'DELETE',
      url: that.url,
      dataType: 'JSON',
      success: function (data) {
        that.followState = 'unfollowed';
        that.render();
      },
      fail: function (data) {
        console.log("Follow request failed")
      }
    })
  };


  $.fn.followToggle = function (options) {
    return this.each(function () {
      new $.FollowToggle(this, options);
    });
  };

  $(function () {
    $("button.follow-toggle").followToggle();
  });
