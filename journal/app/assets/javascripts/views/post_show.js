Journal.Views.PostShowView = Backbone.View.extend({
  events: {
    'click .delete': 'deletePost',
    'dblclick .post' : 'edit',
    'blur .post' : 'submitEdit'
  },


  template: JST['post_show'],

  initialize: function (options) {
    this.model = options.model;
    this.listenTo(this.model, "sync", this.render);
  },

  render: function () {
    var content = this.template({post: this.model});
    this.$el.html(content);
    return this;
  },

  edit: function () {
    var target = $(event.target);

    if (target.context.tagName === "P") {
      $(event.target).html($("<textarea class='postedit'>" + target.html() + "</textarea>"));
    } else {
      $(event.target).html($("<input class='postedit'type='text' value='" + target.html() + "'></input>"));
    }
  },

  submitEdit: function () {
    var target = $(event.target);
    var attributes = {};
    if (target.context.tagName === "INPUT") {
      attributes.title = target.val();
    } else {
      attributes.body = target.val();
    }

    this.model.save(attributes, {
      wait: true,

      success: function () {
        Journal.posts.add(this.model, {merge: true});
      }.bind(this),

      error: function () {
        this.$('ul.posterror').empty();
        this.errors = arguments[1].responseJSON;
        this.errors.forEach(function (error) {
          this.$('ul.posterror').append("<li>" + error + "</li>");
        })
        this.errors = [];

        this.$('div.title').html("<h3>" + this.model.get("title") + "</h3>");

        this.$('div.body').html("<p>" + this.model.get("body") + "</p>");
      }.bind(this)
    });
  },

  deletePost: function () {
    var id = $(event.target).data('id');
    var post = this.collection.get(id);
    post.destroy();
    this.$el.empty();
  }

})
