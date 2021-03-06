// Generated by CoffeeScript 1.7.1
(function() {
  window.Button = (function() {
    function Button(options) {
      this.x = options.x || 0;
      this.y = options.y || 0;
      this.width = options.width || 0;
      this.height = options.height || 0;
      this.text = options.text || 0;
      this.hoveredText = options.hoveredText || 0;
      this.hovered = false;
      this.clicked = false;
    }

    Button.prototype.update = function(deltaTime) {
      var mouseX, mouseY;
      mouseX = getMouseX();
      mouseY = getMouseY();
      this.hovered = mouseX >= this.x && mouseX <= this.x + this.width && mouseY >= this.y && mouseY <= this.y + this.height;
      return this.clicked = this.hovered && isMousePressed();
    };

    Button.prototype.render = function(context) {
      var text;
      context.fillStyle = this.hovered ? Colour.BUTTON_HOVER_BACKGROUND : Colour.TEXT_BACKGROUND;
      context.fillRect(this.x, this.y, this.width, this.height);
      context.beginPath();
      context.strokeStyle = Colour.TEXT;
      context.lineWidth = OUTLINE_THICKNESS;
      context.rect(this.x, this.y, this.width, this.height);
      context.stroke();
      context.fillStyle = Colour.TEXT;
      context.font = BODY_FONT;
      context.textAlign = "center";
      context.textBaseline = "middle";
      text = this.hovered ? this.hoveredText : this.text;
      return context.fillText(text, this.x + (this.width / 2), this.y + (this.height / 2));
    };

    return Button;

  })();

}).call(this);
