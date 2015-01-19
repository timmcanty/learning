window.Journal = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    this.posts = new Journal.Collections.Posts;
    this.posts.fetch();
    var sideBarIndex = new Journal.Views.PostIndexView({collection: this.posts});
    $('#sidebar').html(sideBarIndex.render().$el);
    var postsRouter = new Journal.Routers.Posts({$rootEl:$('#posts')});
    Backbone.history.start()
  }
};

$(document).ready(function(){
  Journal.initialize();
});
