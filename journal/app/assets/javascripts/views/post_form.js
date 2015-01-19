Journal.Views.PostFormView = Backbone.View.extend({

  events: {
    "submit" : "submitForm"
  },

  initialize: function (options) {
    // this.model = options.model;
    this.listenTo(this.model, 'sync', this.render);
    this.errors = [];
  },

  template: JST['post_form'],

  submitForm: function () {
    event.preventDefault();
    var formData = $(event.target).serializeJSON();
    var post = new Journal.Models.Post;
    post.set({title: formData.post.title, body: formData.post.body});
    this.model.save(post.attributes,{
      success: function () {
        this.collection.add(this.model, {merge: true});
        Backbone.history.navigate('#/posts/' + this.model.get('id'), {trigger: true});
      }.bind(this),
      error: function () {
        this.errors = arguments[1].responseJSON;
        this.renderErrors();
      }.bind(this)
    })
  },

  render: function (attrs) {
    var attributes = attrs || this.model.attributes;
    var content = this.template({attributes: attributes});
    this.$el.html(content);
    return this;
  },

  renderErrors: function () {
    this.errors.forEach(function (error) {
      this.$el.find('.errors').append("<li>" + error + "</li>")
    }.bind(this));

    this.errors = [];
  }

})
