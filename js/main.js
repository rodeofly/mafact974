// Generated by CoffeeScript 1.9.0
(function() {
  var CHALLENGES, CURRENT_LEVEL, ECHELLES, Echelle, ID, ILETS, Ilet, SOLUTION, delay, _base,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  if ((_base = Array.prototype).shuffle == null) {
    _base.shuffle = function() {
      var i, j, _i, _ref, _ref1;
      if (this.length > 1) {
        for (i = _i = _ref = this.length - 1; _ref <= 1 ? _i <= 1 : _i >= 1; i = _ref <= 1 ? ++_i : --_i) {
          j = Math.floor(Math.random() * (i + 1));
          _ref1 = [this[j], this[i]], this[i] = _ref1[0], this[j] = _ref1[1];
        }
      }
      return this;
    };
  }

  delay = function(ms, func) {
    return setTimeout(func, ms);
  };

  ID = 1;

  SOLUTION = [];

  ILETS = [];

  ECHELLES = [];

  CURRENT_LEVEL = 0;

  CHALLENGES = {
    1: {
      "ilets": [1, 4, 3],
      "echelles": [3, 1]
    },
    2: {
      "ilets": [1, 4, 3, 5],
      "echelles": [3, 1, 2]
    },
    3: {
      "ilets": [3, 10, 1, 9],
      "echelles": [7, 9, 8]
    },
    4: {
      "ilets": [1, 5, 2, 4, 3],
      "echelles": [4, 3, 2, 1]
    },
    5: {
      "ilets": [1, 10, 4, 9, 2],
      "echelles": [9, 6, 5, 7]
    },
    6: {
      "ilets": [1, 8, 2, 10, 5, 9],
      "echelles": [7, 6, 8, 5, 4]
    },
    7: {
      "ilets": [1, 2, 7, 3, 6, 4],
      "echelles": [1, 5, 4, 3, 2]
    },
    8: {
      "ilets": [1, 2, 4, 10, 5, 9, 6],
      "echelles": [1, 2, 6, 5, 4, 3]
    },
    9: {
      "ilets": [7, 10, 5, 1, 3, 2, 8],
      "echelles": [3, 5, 4, 2, 1, 6]
    },
    10: {
      "ilets": [5, 8, 6, 7, 3, 10, 4, 9],
      "echelles": [3, 2, 1, 4, 7, 6, 5]
    },
    12: {
      "ilets": [1, 2, 10, 3, 9, 4, 8, 5],
      "echelles": [1, 8, 7, 6, 5, 4, 3]
    },
    13: {
      "ilets": [3, 9, 2, 10, 7, 6, 1, 5, 4],
      "echelles": [6, 7, 8, 3, 1, 5, 4, 1]
    },
    14: {
      "ilets": [7, 6, 10, 5, 4, 1, 9, 2, 8],
      "echelles": [1, 4, 5, 1, 3, 8, 7, 6]
    },
    15: {
      "ilets": [2, 9, 1, 10, 4, 7, 3, 8, 5, 6],
      "echelles": [7, 8, 9, 6, 3, 4, 5, 3, 1]
    },
    16: {
      "ilets": [2, 9, 1, 10, 4, 6, 5, 7, 3, 8],
      "echelles": [7, 8, 9, 6, 2, 1, 2, 4, 5]
    }
  };

  Ilet = (function() {
    function Ilet(_at_altitude) {
      this.altitude = _at_altitude;
      this.html = "<div class='spot'>\n    <div class='ilet' data-altitude='" + this.altitude + "'>\n       <span class='info'>" + this.altitude + "</span>       \n    </div>\n    <div class='via' data-denivelle='0'></div>\n</div>";
    }

    return Ilet;

  })();

  Echelle = (function() {
    function Echelle(_at_hauteur) {
      this.hauteur = _at_hauteur;
      this.html = "<div class='echelle' data-hauteur='" + this.hauteur + "'>\n  <span class='info'>" + this.hauteur + "</span>\n</div>";
    }

    return Echelle;

  })();

  $(function() {
    var checkit, draw, html, i, maxi, mini, random, _i;
    mini = function(echelle) {
      var h;
      h = echelle.attr("data-hauteur");
      echelle.css({
        position: "relative",
        height: (25 * h) + "px",
        width: "25px",
        backgroundSize: "100% 100%",
        background: "url(css/images/uniteS.png) repeat-y"
      });
      return echelle.find(".info").css({
        top: "5px",
        left: "8px",
        fontSize: "1em",
        color: "black"
      });
    };
    maxi = function(echelle) {
      var h;
      h = echelle.attr("data-hauteur");
      echelle.css({
        position: "absolute",
        height: (50 * h) + "px",
        width: "50px",
        backgroundSize: "100% 100%",
        background: "url(css/images/unite.png) repeat-y"
      });
      return echelle.find(".info").css({
        top: "10px",
        left: "15px",
        fontSize: "2em",
        color: "grey"
      });
    };
    html = "<div id='close'>X</div><div id='levels'>";
    for (i = _i = 1; _i <= 16; i = ++_i) {
      html += "<div class='level' data-level='" + i + "'>" + i + "</div>";
    }
    html += "<div class='more'>+</div>";
    html += "<div id='more'>\n    <div id='random'>Aléatoire</div>\n    <div id='solution'>Soluce</div>\n    <div id='sliderInfo'>Niveaux :\n        <span id='amount-slider'></span>\n        <div id='slider'></div>\n    </div>\n </div></div>";
    $("#parametres").append(html);
    $("#parametres").draggable();
    $("#param_button").button().on("click", function() {
      $("#more").hide();
      return $("#parametres").toggle();
    });
    checkit = function() {
      var bleues, climbAndJump, delai, scales;
      $(".echelle").removeClass("shine-right shine-wrong");
      $(".spot").each(function() {
        var $next_spot, bottom, curr_alt, current_scale, deniv, height, next_alt, scale, via, x;
        $next_spot = $(this).next(".spot");
        via = $(this).find(".via");
        if ($next_spot.length) {
          curr_alt = parseInt($(this).find(".ilet").attr("data-altitude"));
          next_alt = parseInt($next_spot.find(".ilet").attr("data-altitude"));
          deniv = curr_alt - next_alt;
          height = Math.abs(deniv);
          x = deniv > 0 ? next_alt : curr_alt;
          bottom = (x * 50) + "px";
          via.attr("data-denivelle", deniv).css({
            height: (height * 50) + "px",
            bottom: "" + bottom
          });
          if (via.find(".echelle").length > 0) {
            scale = parseInt(via.find(".echelle").attr("data-hauteur"));
            if (scale === height) {
              return via.find(".echelle").addClass("shine-right");
            } else {
              current_scale = via.find(".echelle").appendTo($("#echelles"));
              return mini(current_scale);
            }
          }
        } else {
          return via.hide();
        }
      });
      bleues = $(".shine-right").length;
      scales = $(".echelle").length;
      delai = 100;
      climbAndJump = function(c, i) {
        var alt, d, parent, spot, via;
        parent = $("#facteur").parent();
        if (parent.hasClass("ilet")) {
          via = parent.siblings(".via");
          if (via.find(".echelle").length > 0) {
            d = parseInt(via.attr("data-denivelle"));
            return delay(delai, function() {
              via.find(".echelle").append($("#facteur"));
              i = Math.abs(d);
              if (d > 0) {
                $("#facteur").css({
                  bottom: "auto",
                  top: "-50px",
                  left: "40%"
                });
                return climbAndJump(1, i);
              } else {
                $("#facteur").css({
                  top: "auto",
                  bottom: "0px",
                  left: "40%"
                });
                return climbAndJump(-1, i);
              }
            });
          } else {
            if (!$("#facteur").closest(".spot").is($(".spot:last"))) {
              return console.log("done");
            }
          }
        } else {
          if (i) {
            i--;
            alt = parseInt($("#facteur").css("top"));
            return delay(delai, function() {
              $("#facteur").css({
                top: (alt + c * 50) + "px"
              });
              return climbAndJump(c, i);
            });
          } else {
            spot = $("#facteur").closest(".spot").next(".spot").find(".ilet");
            return delay(delai, function() {
              spot.append($("#facteur"));
              $("#facteur").css({
                top: "-50px",
                left: "40%"
              });
              return climbAndJump(c, i);
            });
          }
        }
      };
      climbAndJump();
      if (bleues === scales) {
        $("#echelles").append("<div id='gagne'>Oté, c'est gagné !</div>");
        $("#laReunion").fireworks();
        $(".echelle").draggable("destroy");
        $("#mafate").sortable("destroy");
        $(".level[data-level='" + CURRENT_LEVEL + "']").addClass("green");
        return delay(5000, function() {
          return $("#parametres").show();
        });
      }
    };
    draw = function() {
      var echelle, h, height, ilet, _j, _k, _len, _len1;
      $("#mafate, #echelles").empty();
      for (_j = 0, _len = ILETS.length; _j < _len; _j++) {
        i = ILETS[_j];
        ilet = new Ilet(i);
        $("#mafate").append(ilet.html);
        $(".ilet[data-altitude='" + ilet.altitude + "']").css({
          height: (50 * i) + "px"
        });
      }
      height = $("#mafate .ilet:first").attr("data-altitude");
      $("#riveG").css({
        backgroundSize: "100px " + (height * 50) + "px",
        backgroundPosition: "bottom"
      });
      $(".spot:first .ilet").append("<div id='facteur'></div>");
      $("#facteur").css({
        top: "-50px",
        left: "40%"
      });
      height = $("#mafate .ilet:last").attr("data-altitude");
      h = $(".spot:last").height() - height * 50;
      $(".spot:last").css({
        background: "url(css/images/case.png) no-repeat",
        backgroundPosition: "25px " + (h - 50) + "px"
      });
      $("#riveD").css({
        backgroundSize: "100px " + (height * 50) + "px",
        backgroundPosition: "bottom"
      });
      for (_k = 0, _len1 = ECHELLES.length; _k < _len1; _k++) {
        i = ECHELLES[_k];
        echelle = new Echelle(i);
        $("#echelles").append(echelle.html);
        echelle = $(".echelle[data-hauteur='" + echelle.hauteur + "']");
        mini(echelle);
      }
      $("#mafate").sortable({
        items: '.spot:not(:first, :last)',
        stop: function() {
          $(".spot:first .ilet").append($("#facteur"));
          return checkit();
        }
      });
      $("#echelles").draggable({
        containment: "#laReunion"
      });
      $(".echelle").draggable({
        helper: "clone",
        appendTo: "body",
        revert: function(valid_drop) {
          if (!valid_drop) {
            if ($(this).parent().is("#echelles")) {
              return mini($(this));
            }
          } else {
            return true;
          }
        },
        start: function(event, ui) {
          ui.helper.css('z-index', "10");
          return maxi(ui.helper);
        }
      });
      $("#echelles, #mafate").droppable({
        tolerance: 'touch',
        accept: '.echelle',
        drop: function(event, ui) {
          ui.helper.remove();
          $("#echelles").append(ui.draggable);
          return mini(ui.draggable);
        }
      });
      return $(".via").droppable({
        tolerance: 'touch',
        accept: '.echelle',
        activeClass: "shine-yellow",
        hoverClass: "shine-white",
        drop: function(event, ui) {
          var current_scale, scaleHeight, viaHeight;
          ui.helper.remove();
          viaHeight = Math.abs(parseInt($(this).attr("data-denivelle")));
          scaleHeight = parseInt(ui.draggable.attr("data-hauteur"));
          current_scale = $(this).find(".echelle");
          if (viaHeight === scaleHeight) {
            $(this).append(ui.draggable);
            maxi(ui.draggable);
            if (current_scale.length) {
              $("#echelles").append(current_scale);
              mini(current_scale);
            }
            return checkit();
          } else {
            return ui.draggable.draggable('option', 'revert', function() {
              if ($(this).parent().is("#echelles")) {
                mini($(this));
              }
              return true;
            });
          }
        }
      });
    };
    random = function(n) {
      var c, e, elu, first, ilet, j, k, last, lop, _j, _k, _ref, _ref1, _ref2, _ref3, _ref4;
      _ref = [[], [Math.floor(Math.random() * 10) + 1]], ECHELLES = _ref[0], ILETS = _ref[1];
      _ref1 = [true, 0], lop = _ref1[0], k = _ref1[1];
      while (lop && (k < 1000)) {
        _ref2 = [false, k + 1], lop = _ref2[0], k = _ref2[1];
        for (i = _j = 0, _ref3 = n - 1; 0 <= _ref3 ? _j <= _ref3 : _j >= _ref3; i = 0 <= _ref3 ? ++_j : --_j) {
          e = [];
          for (j = _k = -10; _k <= 10; j = ++_k) {
            c = ILETS[i] + j;
            if (!((j === 0) || (_ref4 = Math.abs(j), __indexOf.call(ECHELLES, _ref4) >= 0) || (__indexOf.call([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], c) < 0) || (__indexOf.call(ILETS, c) >= 0))) {
              e.push(j);
            }
          }
          if (e.length) {
            elu = (e.shuffle())[0];
            ECHELLES.push(Math.abs(elu));
            ilet = ILETS[i] + elu;
            ILETS.push(ilet);
          } else {
            lop = true;
            break;
          }
        }
      }
      SOLUTION = ILETS.slice(0);
      ILETS = SOLUTION.slice(0);
      first = ILETS.shift();
      last = ILETS.pop();
      ILETS.shuffle();
      ILETS = [first].concat(ILETS).concat([last]);
      ECHELLES.shuffle();
      draw();
      return checkit();
    };
    $("#amount-slider").html("7");
    $("#slider").slider({
      range: "max",
      min: 2,
      max: 7,
      step: 1,
      value: 6,
      slide: function(event, ui) {
        var n;
        $("#gagne").remove();
        $("#laReunion").fireworks('destroy');
        $("#amount-slider").html(ui.value);
        return random(n = parseInt($("#amount-slider").html()));
      }
    });
    $(".level").button().on("click", function() {
      var first, last, level, _ref;
      $("#parametres").hide();
      level = parseInt($(this).attr("data-level"));
      $("#gagne").remove();
      $("#laReunion").fireworks('destroy');
      SOLUTION = CHALLENGES[level].ilets;
      ECHELLES = CHALLENGES[level].echelles.shuffle();
      ILETS = SOLUTION.slice(0);
      _ref = [ILETS.shift(), ILETS.pop()], first = _ref[0], last = _ref[1];
      ILETS = [first].concat(ILETS.shuffle()).concat([last]);
      SOLUTION = [];
      CURRENT_LEVEL = level;
      draw();
      return checkit();
    });
    $("#close").button().on("click", function() {
      return $("#parametres").hide();
    });
    $("#random").button().on("click", function() {
      var n;
      $("#gagne").remove();
      $("#laReunion").fireworks('destroy');
      return random(n = parseInt($("#amount-slider").html()));
    });
    $("#solution").button().on("click", function() {
      if (SOLUTION.length > 0) {
        ILETS = SOLUTION;
      }
      draw();
      return checkit();
    });
    $(".more").button().on("click", function() {
      return $("#more").show();
    });
    $("#random").trigger("click");
    return $("#param_button").trigger("click");
  });

}).call(this);
