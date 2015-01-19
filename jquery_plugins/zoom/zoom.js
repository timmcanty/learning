(function() {
  if ($ === "undefined"){
    window.$ = {};
  }

  $.Zoom = function ($el) {
    console.log("here")
    var frame = this;
    this.$el = $($el);
    console.log(this.$el);
    this.focusBoxSize = 100;

    this.$el.on('mouseenter', 'img', function (event) {
      frame.$el.append("<div class=\"focus-box\"></div")
      frame.showFocusBox(event);
    })


    this.$el.on('mousemove', 'img, .focus-box', function (event) {
      frame.showFocusBox(event);
    });

    this.$el.on('mouseleave',  function (event) {
      frame.removeFocusBox(event);
    });
  };


  $.Zoom.prototype.showFocusBox = function (event) {
    var left = event.pageX
    var top = event.pageY
    var $focusBox = $(".focus-box");

    if (left > 500 && top > 338) { this.removeFocusBox(event);}

    if (left > 400) { left = 400; }
    if (top > 238) { top = 238; }




    $focusBox.css('top',top + "px");
    $focusBox.css('left',left + "px");
  }

  $.Zoom.prototype.removeFocusBox = function (event) {
    console.log("i am here");
    $(".focus-box").remove();
  }

  // $.Zoom.prototype.showZoom = function (xDiff,yDiff) {
  //   var $zoomedImg = $("<div class=\"zoomed-image\"></div");
  //   $('body').append($zoomedImg);
  //   $zoomedImg.attr('height','100%')
  //   $zoomedImg.css('background-img', "http://jokideo.com/wp-content/uploads/2013/05/57.jpg")
  // }




  $.fn.zoom = function () {
    console.log(this)
    return this.each(function () {
      new $.Zoom(this);
    });
  };




}());
