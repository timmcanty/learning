(function() {
  if ($ === "undefined"){
    window.$ = {};
  }

  $.Carousel = function ($el) {
    this.$el = $($el);
    this.activeIdx = 0;
    this.transitioning = false

    this.$el.on('click', '.slide-left', function (event) {
      if (this.transitioning) {
        return;
      }
      this.transitioning = true;

      var $currentChild = $('li').eq(this.activeIdx);
      var leftIdx = $.Carousel.correctIdx(this.activeIdx - 1);
      var $nextChild = $('li').eq(leftIdx);

      $nextChild.addClass('active left');
      setTimeout( function () {
        $nextChild.removeClass('left');
        $currentChild.addClass('right');
      },0);


      this.activeIdx--;
      this.activeIdx = $.Carousel.correctIdx(this.activeIdx);
      $("li").eq(this.activeIdx).addClass("active");

      this.$el.one('transitionend', 'li', function(event) {
        $currentChild.removeClass('active right');
        this.transitioning = false;
      }.bind(this));

    }.bind(this));

    this.$el.on('click', '.slide-right', function (event) {
      if (this.transitioning) {
        return;
      }
      this.transitioning = true;

      var $currentChild = $('li').eq(this.activeIdx);
      var rightIdx = $.Carousel.correctIdx(this.activeIdx + 1);
      var $nextChild = $('li').eq(rightIdx);

      $nextChild.addClass('active right');
      setTimeout( function () {
        $nextChild.removeClass('right');
        $currentChild.addClass('left');
      },0);


      this.activeIdx++ ;
      this.activeIdx = $.Carousel.correctIdx(this.activeIdx);
      $("li").eq(this.activeIdx).addClass("active");

      this.$el.one('transitionend', 'li', function(event) {
        $currentChild.removeClass('active left');
        this.transitioning = false;
      }.bind(this));

    }.bind(this));

  }

  $.Carousel.correctIdx = function (idx) {
    if (idx < 0) {
      return idx + 3;
    } else if (idx > 2) {
      return idx -3;
    } else {
      return idx;
    }
  };


  $.fn.carousel = function () {
    console.log(this)
    return this.each(function () {
      new $.Carousel(this);
    });
  };

}());
