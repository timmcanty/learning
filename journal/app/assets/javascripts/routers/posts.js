Journal.Routers.Posts = Backbone.Router.extend({

  initialize: function (options) {
    this.$rootEl = options.$rootEl;
  },

  routes:  {
    '': 'index',
    'posts/new' : 'new',
    'posts/:id': 'show',
    'posts/:id/edit': 'edit'
  },

  index: function() {
    var postsIndexView = new Journal.Views.PostIndexView({
      collection: Journal.posts
    });

    this.$rootEl.html(postsIndexView.render().$el);
  },

  show: function (id) {
    var post = Journal.posts.getOrFetch(id);
    var showView = new Journal.Views.PostShowView({
      model: post,
      collection: Journal.posts
    });

    this.$rootEl.html(showView.render().$el);
  },

  edit: function (id) {
    var post = Journal.posts.getOrFetch(id);
    var editView = new Journal.Views.PostFormView({
      model: post,
      collection: Journal.posts
    });

    this.$rootEl.html(editView.render().$el);
  },

  new: function () {
    var post = new Journal.Models.Post();
    var newView = new Journal.Views.PostFormView({
      model: post,
      collection: Journal.posts
    });

    this.$rootEl.html(newView.render().$el);
  }

})
