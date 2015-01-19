Journal.Views.PostIndexView = Backbone.View.extend({
  events: {
    'click .delete': 'deletePost'
  },

  template: JST['posts_index'],

  initialize: function (options) {
    this.collection = options.collection;
    this.listenTo(this.collection, "add change:title remove reset sync", this.render);
  },

  render: function () {
    var content = this.template({posts: this.collection});
    this.$el.html(content);
    return this;
  },

  deletePost: function () {
    var id = $(event.target).data('id');
    var post = this.collection.get(id);
    post.destroy();
  }
});
