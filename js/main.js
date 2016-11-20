// Generated by CoffeeScript 1.10.0
(function() {
  var CHALLENGES, ECHELLES, Echelle, ID, ILETS, Ilet, SOLUTION, base,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  if ((base = Array.prototype).shuffle == null) {
    base.shuffle = function() {
      var i, j, l, ref, ref1;
      if (this.length > 1) {
        for (i = l = ref = this.length - 1; ref <= 1 ? l <= 1 : l >= 1; i = ref <= 1 ? ++l : --l) {
          j = Math.floor(Math.random() * (i + 1));
          ref1 = [this[j], this[i]], this[i] = ref1[0], this[j] = ref1[1];
        }
      }
      return this;
    };
  }

  ID = 1;

  SOLUTION = [];

  ILETS = [];

  ECHELLES = [];

  CHALLENGES = {
    7: {
      "ilets": [1, 2, 10, 3, 9, 4, 8, 5],
      "echelles": [1, 3, 4, 5, 6, 7, 8]
    }
  };

  Ilet = (function() {
    function Ilet(altitude) {
      this.altitude = altitude;
      this.html = "<div class='spot'>\n    <div class='ilet' data-altitude='" + this.altitude + "'>\n       <span class='info'>" + this.altitude + "</span>       \n    </div>\n    <div class='via' data-denivelle='0'></div>\n</div>";
    }

    return Ilet;

  })();

  Echelle = (function() {
    function Echelle(hauteur) {
      this.hauteur = hauteur;
      this.html = "<div class='echelle' data-hauteur='" + this.hauteur + "'>\n  <span class='info'>" + this.hauteur + "</span>\n</div>";
    }

    return Echelle;

  })();

  $(function() {
    var checkit, draw, html, i, l, random;
    html = "<div id='random'>Aléatoire</div><div id='solution'>Soluce</div><div id='close'>X</div>";
    html += "<div id='sliderInfo'>Niveaux :<span id='amount-slider'></span><div id='slider'></div></div><br><h2>Challenges</h2>";
    for (i = l = 7; l <= 7; i = ++l) {
      html += "<div class='level' data-level='" + i + "'>" + i + "</div>";
    }
    $("#parametres").append(html);
    $("#parametres").draggable();
    $("#param_button").button().on("click", function() {
      return $("#parametres").toggle();
    });
    checkit = function() {
      var bleues, scales;
      $(".echelle").removeClass("shine-right shine-wrong");
      $(".spot").each(function() {
        var $next_spot, bottom, curr_alt, deniv, height, next_alt, scale, via;
        $next_spot = $(this).next(".spot");
        via = $(this).find(".via");
        if ($next_spot.length) {
          curr_alt = parseInt($(this).find(".ilet").attr("data-altitude"));
          next_alt = parseInt($next_spot.find(".ilet").attr("data-altitude"));
          deniv = curr_alt - next_alt;
          height = Math.abs(deniv);
          bottom = (deniv > 0 ? next_alt : curr_alt) + "0%";
          via.attr("data-denivelle", deniv).css({
            height: height + "0%",
            bottom: "" + bottom
          });
          if (via.find(".echelle").length > 0) {
            scale = parseInt(via.find(".echelle").attr("data-hauteur"));
            if (scale === height) {
              return via.find(".echelle").addClass("shine-right");
            } else {
              return via.find(".echelle").appendTo($("#echelles"));
            }
          }
        } else {
          scale = via.find(".echelle");
          scale.appendTo("#echelles");
          return via.hide();
        }
      });
      bleues = $(".shine-right").length;
      scales = $(".echelle").length;
      if (bleues === scales) {
        $("#echelles").append("<div id='gagne'>Oté, c'est gagné !</div>");
        return $("#mafate").fireworks();
      }
    };
    draw = function() {
      var echelle, ilet, len, len1, m, o;
      $("#mafate, #echelles").empty();
      for (m = 0, len = ILETS.length; m < len; m++) {
        i = ILETS[m];
        ilet = new Ilet(i);
        $("#mafate").append(ilet.html);
        $(".ilet[data-altitude='" + ilet.altitude + "']").css({
          height: (50 * i) + "px"
        });
      }
      for (o = 0, len1 = ECHELLES.length; o < len1; o++) {
        i = ECHELLES[o];
        echelle = new Echelle(i);
        $("#echelles").append(echelle.html);
        $(".echelle[data-hauteur='" + echelle.hauteur + "']").css({
          height: (50 * i) + "px"
        });
      }
      $("#mafate").sortable({
        items: '.spot:not(:first, :last)',
        stop: function() {
          return checkit();
        }
      });
      $("#echelles").draggable();
      $(".echelle").draggable({
        revert: true
      });
      return $(".via").droppable({
        tolerance: 'touch',
        accept: '.echelle',
        activeClass: "shine-yellow",
        hoverClass: "shine-white",
        drop: function(event, ui) {
          var current_scale, scaleHeight, viaHeight;
          viaHeight = Math.abs(parseInt($(this).attr("data-denivelle")));
          scaleHeight = parseInt(ui.draggable.attr("data-hauteur"));
          current_scale = $(this).find(".echelle");
          if (viaHeight === scaleHeight) {
            if (current_scale.length) {
              $("#echelles").append(current_scale);
            }
            $(this).append($(ui.draggable));
            $(this).find(".echelle").css({
              position: "absolute",
              left: "0",
              top: "0"
            });
            return checkit();
          }
        }
      });
    };
    random = function(n) {
      var c, e, elu, first, ilet, j, k, last, lop, m, o, ref, ref1, ref2, ref3, ref4;
      ref = [[], [Math.floor(Math.random() * 10) + 1]], ECHELLES = ref[0], ILETS = ref[1];
      ref1 = [true, 0], lop = ref1[0], k = ref1[1];
      while (lop && (k < 1000)) {
        ref2 = [false, k + 1], lop = ref2[0], k = ref2[1];
        for (i = m = 0, ref3 = n - 1; 0 <= ref3 ? m <= ref3 : m >= ref3; i = 0 <= ref3 ? ++m : --m) {
          e = [];
          for (j = o = -10; o <= 10; j = ++o) {
            c = ILETS[i] + j;
            if (!((j === 0) || (ref4 = Math.abs(j), indexOf.call(ECHELLES, ref4) >= 0) || (indexOf.call([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], c) < 0) || (indexOf.call(ILETS, c) >= 0))) {
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
        $("#mafate").fireworks('destroy');
        $("#amount-slider").html(ui.value);
        return random(n = parseInt($("#amount-slider").html()));
      }
    });
    $(".level").button().on("click", function() {
      var first, last, level, ref;
      $("#parametres").hide();
      level = parseInt($(this).attr("data-level"));
      $("#gagne").remove();
      $("#mafate").fireworks('destroy');
      SOLUTION = CHALLENGES[level].ilets;
      ECHELLES = CHALLENGES[level].echelles.shuffle();
      ILETS = SOLUTION.slice(0);
      ref = [ILETS.shift(), ILETS.pop()], first = ref[0], last = ref[1];
      ILETS = [first].concat(ILETS.shuffle()).concat([last]);
      SOLUTION = [];
      draw();
      return checkit();
    });
    $("#close").button().on("click", function() {
      return $("#parametres").hide();
    });
    $("#random").button().on("click", function() {
      var n;
      $("#gagne").remove();
      $("#mafate").fireworks('destroy');
      return random(n = parseInt($("#amount-slider").html()));
    });
    $("#solution").button().on("click", function() {
      if (SOLUTION.length > 0) {
        ILETS = SOLUTION;
      }
      draw();
      return checkit();
    });
    return $("#random").trigger("click");
  });

}).call(this);
