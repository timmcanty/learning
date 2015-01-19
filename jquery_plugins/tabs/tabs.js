(function() {
  if (typeof $ === "undefined"){
    window.$ = {};
  };




$.Tabs = function(el) {
  this.$el = $(el);
  this.$contentTabs = $(this.$el.data("content-tabs"));
  this.$activeTab = this.$contentTabs.children( ".active" );
  this.$activeLink = $("a.active");
  console.log(this.$activeLink);
  this.$el.on('click', 'a', function(event) {
    this.clickTab(event);
  }.bind(this));
};

$.Tabs.prototype.clickTab = function (event) {
  event.preventDefault();
  this.$activeTab.addClass("transitioning");
  this.$activeLink.removeClass("active");
  var $newActiveLink = $(event.target);
  $newActiveLink.addClass("active");
  this.$activeLink = $newActiveLink;
  $($newActiveLink.attr("href")).addClass("transitioning");
  this.$activeTab.one('transitionend', function(event){
    this.$activeTab.removeClass("transitioning");
    this.$activeTab.removeClass("active");

    var $newActiveTab = $($newActiveLink.attr("href"));
    this.$activeTab = $newActiveTab;
    this.$activeTab.addClass("active");
    this.$activeTab.removeClass("transitioning");

  }.bind(this))




}

$.fn.tabs = function () {
  return this.each(function () {
    new $.Tabs(this);
  });
};

}());
