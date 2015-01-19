

  $.Thumbnails = function ($el) {
    this.$el = $($el);
    this.$gutterImages = $(".gutter-images");
    this.$allImages = this.$gutterImages.clone().children();
    this.$activeImage = $(".active");
    this.$activeImg = $("img").eq(0);
    this.gutterIdx = 0;


    this.activate(this.$activeImg);
    this.fillGutterImages();
    this.$el.on('click', 'img', function (event) {
      $targetThumb = $(event.currentTarget);
      this.$activeImg = $targetThumb;

      this.activate(this.$activeImg);
    }.bind(this));

    this.$el.on('mouseenter', 'img', function (event) {
      $targetThumb = $(event.currentTarget);
      this.activate($targetThumb);
    }.bind(this));

    this.$el.on('mouseleave', 'img', function (event) {
      this.activate(this.$activeImg);
    }.bind(this));

    this.$el.on('click', 'a', function (event) {
      if($(event.target).hasClass('right') && this.gutterIdx != 15) {
        this.moveGutter(1);
      } else if ($(event.target).hasClass('left') && this.gutterIdx != 0) {
        this.moveGutter(-1);
      }
    }.bind(this));


  };

  $.Thumbnails.prototype.moveGutter = function (dir) {
    console.log("HWIOHAFGIONWEFO");
    this.gutterIdx += dir;
    this.fillGutterImages();
  };

  $.Thumbnails.prototype.fillGutterImages = function () {
    this.$gutterImages.empty();
    for (var i = this.gutterIdx; i < this.gutterIdx + 5; i++) {
      $nextGutter = this.$allImages[i];
      this.$gutterImages.append($nextGutter);
    }
  };

  $.Thumbnails.prototype.activate = function ($img) {
    this.$activeImage.empty();
    $clonedImg = $img.clone();
    this.$activeImage.append($clonedImg);
  };


  $.fn.thumbnails = function () {
    return this.each(function () {
      new $.Thumbnails(this);
    });
  };
