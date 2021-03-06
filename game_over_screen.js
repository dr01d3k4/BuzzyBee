// Generated by CoffeeScript 1.7.1
(function() {
  var gameOverNameEnterFunction, gameOverPlayerName, maxGameOverPlayerNameLength,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  gameOverPlayerName = "";

  maxGameOverPlayerNameLength = 8;

  gameOverNameEnterFunction = function(keyCode) {
    if (keyCode === 8) {
      gameOverPlayerName = gameOverPlayerName.substring(0, gameOverPlayerName.length - 1);
    }
    if (gameOverPlayerName.length < maxGameOverPlayerNameLength && ((48 <= keyCode && keyCode <= 57) || (65 <= keyCode && keyCode <= 90) || (97 <= keyCode && keyCode <= 122))) {
      return gameOverPlayerName += String.fromCharCode(keyCode).toLowerCase();
    }
  };

  window.GameOverScreen = (function(_super) {
    __extends(GameOverScreen, _super);

    function GameOverScreen(score, backgroundScroll) {
      var data, scores;
      this.score = score;
      this.backgroundScroll = backgroundScroll;
      this.spacePressed = 0;
      this.spaceMaxPressed = 3;
      data = loadGame();
      scores = data[SAVE_HIGHSCORE_TITLE];
      sortScoreArray(scores);
      this.isHighscore = (scores.length === 0 || (scores.length > 0 && this.score >= scores[0][0])) && this.score !== 0;
      this.inHighscoreList = this.isHighscore || scores.length < SAVE_HIGHSCORE_COUNT || (scores.length > 0 && this.score >= scores[scores.length - 1][0] && this.score !== 0);
      this.menuButton = new Button({
        x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN,
        y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT,
        width: GAME_OVERLAY_BUTTON_WIDTH,
        height: GAME_OVERLAY_BUTTON_HEIGHT,
        text: "Menu",
        hoveredText: "> Menu <"
      });
      this.playAgain = new Button({
        x: GAME_OVERLAY_X + GAME_OVERLAY_BUTTON_MARGIN + (GAME_OVERLAY_WIDTH * 0.5),
        y: GAME_OVERLAY_Y + GAME_OVERLAY_HEIGHT - GAME_OVERLAY_BUTTON_MARGIN - GAME_OVERLAY_BUTTON_HEIGHT,
        width: GAME_OVERLAY_BUTTON_WIDTH,
        height: GAME_OVERLAY_BUTTON_HEIGHT,
        text: "Play again",
        hoveredText: "> Play again <"
      });
      gameOverPlayerName = data[SAVE_LAST_NAME_TITLE];
      setRespondToKeyDownFunction(gameOverNameEnterFunction);
      this.time = 0;
    }

    GameOverScreen.prototype.saveScore = function() {
      return addScore(this.score, gameOverPlayerName);
    };

    GameOverScreen.prototype.tryClose = function() {
      if (this.inHighscoreList && gameOverPlayerName.length > 0) {
        this.saveScore();
        return true;
      } else if (!this.highscore && !this.inHighscoreList) {
        return true;
      } else {
        return false;
      }
    };

    GameOverScreen.prototype.update = function(deltaTime) {
      this.time += deltaTime;
      this.menuButton.update(deltaTime);
      this.playAgain.update(deltaTime);
      if (this.menuButton.clicked) {
        if (this.tryClose()) {
          changeScreen(new MainMenuScreen());
        }
        return;
      }
      if (this.playAgain.clicked) {
        if (this.tryClose()) {
          changeScreen(new GameScreen());
        }
      }
    };

    GameOverScreen.prototype.render = function(context) {
      var text, textWidth;
      context.drawImage(backgroundCanvas, this.backgroundScroll, 0);
      context.drawImage(backgroundCanvas, this.backgroundScroll + BACKGROUND_WIDTH, 0);
      context.fillStyle = Colour.TEXT_BACKGROUND;
      context.fillRect(GAME_OVERLAY_X, GAME_OVERLAY_Y, GAME_OVERLAY_WIDTH, GAME_OVERLAY_HEIGHT);
      context.beginPath();
      context.strokeStyle = Colour.TEXT;
      context.lineWidth = OUTLINE_THICKNESS;
      context.rect(GAME_OVERLAY_X, GAME_OVERLAY_Y, GAME_OVERLAY_WIDTH, GAME_OVERLAY_HEIGHT);
      context.stroke();
      context.fillStyle = Colour.TEXT;
      context.font = GAME_OVERLAY_TITLE_FONT;
      context.textAlign = "center";
      context.textBaseline = "middle";
      context.fillText("Game Over!", GAME_OVERLAY_TITLE_TEXT_X, GAME_OVERLAY_TITLE_TEXT_Y);
      context.font = BODY_FONT;
      context.fillText("Score: " + this.score, GAME_OVERLAY_BODY_TEXT_X, GAME_OVERLAY_BODY_TEXT_Y);
      if (this.isHighscore) {
        context.fillText("New highscore!", GAME_OVERLAY_BODY_TEXT_X, GAME_OVERLAY_BODY_TEXT_Y + 64);
      }
      if (this.inHighscoreList) {
        context.textAlign = "left";
        text = "Your name: " + gameOverPlayerName;
        context.fillText(text, GAME_OVERLAY_BODY_TEXT_X * 0.6, GAME_OVERLAY_BODY_TEXT_Y + 128);
        if ((Math.floor(this.time * 10) / 10) - Math.floor(this.time) < 0.6) {
          textWidth = context.measureText(text).width;
          context.fillRect(GAME_OVERLAY_BODY_TEXT_X * 0.6 + textWidth, GAME_OVERLAY_BODY_TEXT_Y + 114, 2, 24);
        }
      }
      this.menuButton.render(context);
      return this.playAgain.render(context);
    };

    GameOverScreen.prototype.close = function() {
      gameOverPlayerName = "";
      return setRespondToKeyDownFunction(null);
    };

    return GameOverScreen;

  })(Screen);

}).call(this);
