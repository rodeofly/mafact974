Array::shuffle ?= ->
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor( Math.random() * (i + 1) )
    [@[i], @[j]] = [@[j], @[i]]
  this

delay = (ms, func) -> setTimeout func, ms

ID = 1
SOLUTION = [] 
ILETS = []
ECHELLES = []
CURRENT_LEVEL = 0

CHALLENGES =
  1:
    "ilets": [1, 4, 3]
    "echelles": [3, 1]
  2:
    "ilets": [1, 3, 4, 5]
    "echelles": [1, 2, 3]
  3:
    "ilets": [3, 1, 10, 9]
    "echelles": [7, 8, 9]
  4:
    "ilets": [1, 2, 4, 5, 3]
    "echelles": [1, 2, 3, 4]
  5:
    "ilets": [1, 4, 9, 10, 2]
    "echelles": [5, 6, 7, 9]
  6:
    "ilets": [1, 2, 5, 8, 10, 9]
    "echelles": [4, 5, 6, 7, 8]
  7:
    "ilets": [1, 2, 3, 6, 7, 4]
    "echelles": [1, 2, 3, 4, 5]
  8:
    "ilets": [1, 2, 4, 5, 9, 10, 6]
    "echelles": [1, 2, 3, 4, 5, 6]
  9:
    "ilets": [7, 1, 2, 3, 5, 10, 8]
    "echelles": [1, 2, 3, 4, 5, 6]
  10:
    "ilets": [5, 3, 4, 6, 7, 8, 10, 9]
    "echelles": [1, 2, 3, 4, 5, 6, 7]
  12:
    "ilets": [1, 2, 3, 4, 8, 9, 10, 5]
    "echelles": [1, 8, 7, 6, 5, 4, 3]
  13:
    "ilets": [3, 1, 2, 5, 6, 7, 9, 10, 4]
    "echelles": [1, 1, 3, 4, 5, 6, 7, 8]
  14:
    "ilets": [7, 1, 2, 4, 5, 6, 9, 10, 8]
    "echelles": [1, 1, 3, 4, 5, 6, 7, 8]
  15:
    "ilets": [2, 1, 3, 4, 5, 7, 8, 9, 10, 6]
    "echelles": [1, 3, 3, 4, 5, 6, 7, 8, 9]
  16:
    "ilets": [2, 1, 3, 4, 5, 6, 7, 9, 10, 8]
    "echelles": [1,2, 2, 4, 5, 6, 7, 8, 9]

######################################################     
class Ilet
######################################################
  constructor: (@altitude) ->
    @html = """
    <div class='spot'>
        <div class='ilet' data-altitude='#{@altitude}'>
           <span class='info'>#{@altitude}</span>       
        </div>
        <div class='via' data-denivelle='0'></div>
    </div>
    """
######################################################   
class Echelle
######################################################
  constructor: (@hauteur) ->
    @html = """
    <div class='echelle' data-hauteur='#{@hauteur}'>
      <span class='info'>#{@hauteur}</span>
    </div>
    """
#reduire une echelle lorsqu'elle retourne sur le nuage
mini = (echelle) ->
  h = echelle.attr "data-hauteur"
  echelle.css
    position: "relative"
    height: "#{25*h}px"
    width: "25px"
    backgroundSize: "100% 100%"
    background: "url(css/images/uniteS.png) repeat-y"
  echelle.find( ".info" ).css
    top : "5px"
    left : "8px"
    fontSize : "1em"
    color : "black"
#augmenter une echelle lorsqu'elle quitte le nuage 
maxi = (echelle) ->
  h = echelle.attr "data-hauteur"
  echelle.css 
    position : "absolute"
    height: "#{50*h}px"
    width: "50px"
    backgroundSize: "100% 100%"
    background: "url(css/images/unite.png) repeat-y"
  echelle.find( ".info" ).css
    top : "10px"
    left : "15px"
    fontSize : "2em"
    color : "grey"

######################################################
# Construction du menu
######################################################
html =  "<div id='close'>x</div><div id='levels'>"
html += "<div class='level' data-level='#{i}'>#{i}</div>" for i in [1..16]
html += "<div class='more'>+</div>"
html += """
<div id='more'>
    <div id='random'>Aléatoire</div>
    <div id='solution'>Soluce</div>
    <div id='sliderInfo'>Niveaux :
        <span id='amount-slider'></span>
        <div id='slider'></div>
    </div>
 </div></div>"""

$ ->  
  $( "#parametres" ).append html
  $( "#parametres" ).draggable()
  $( "#param_button" ).button().on "click", ->
    $( "#more" ).hide()
    $( "#parametres" ).toggle()
    
    
  checkit = -> 
    $( ".echelle" ).removeClass( "shine-right shine-wrong" )
    $( ".spot" ).each ->
      $next_spot = $(this).next(".spot")
      via = $(this).find( ".via" )         
      if $next_spot.length 
        curr_alt = parseInt $(this).find( ".ilet" ).attr( "data-altitude" )
        next_alt = parseInt $next_spot.find( ".ilet" ).attr( "data-altitude" )
        deniv = curr_alt - next_alt
        height = Math.abs deniv
        yPos = if (deniv > 0) then next_alt else curr_alt
        via.attr("data-denivelle", deniv).css
          height: "#{height*50}px"
          bottom: "#{yPos*50}px"
        if via.find( ".echelle" ).length > 0
          scale  = parseInt( via.find( ".echelle" ).attr("data-hauteur") )
          if scale is height
            via.find( ".echelle" ).addClass "shine-right"
          else 
            current_scale = via.find( ".echelle" ).appendTo $( "#echelles"  )
            mini(current_scale)
      else
        via.hide()
    bleues = $( ".shine-right" ).length
    scales = $( ".echelle" ).length
    
    delai = 100
    climbAndJump = (c, i) ->
      parent = $( "#facteur" ).parent()
      if parent.hasClass "ilet"
        via = parent.siblings ".via"
        if via.find( ".echelle").length > 0 
          d = parseInt via.attr( "data-denivelle" )
          delay delai, -> 
            via.find( ".echelle").append $( "#facteur")
            i = Math.abs d 
            if d>0
              $( "#facteur" ).css bottom: "auto", top: "-50px", left: "40%"
              climbAndJump(1, i)
            else
              $( "#facteur" ).css top: "auto", bottom: "0px", left: "40%"
              climbAndJump(-1, i) 
        else
          if $( "#facteur" ).closest( ".spot" ).is $( ".spot:last") 
            $( "#facteur" ).addClass "pause"
      else
        if i
          i--
          alt = parseInt $( "#facteur" ).css( "top" )
          delay delai, -> 
            $( "#facteur" ).css top: "#{alt+c*50}px"
            climbAndJump(c, i)
        else
          spot = $( "#facteur" ).closest( ".spot" ).next(".spot").find( ".ilet" )
          delay delai, -> 
            spot.append $( "#facteur" )
            $( "#facteur" ).css
              top: "-50px"
              left: "40%"
            climbAndJump(c, i)   
    
    if bleues is scales
      $( "#echelles" ).append "<div id='gagne'>Oté, c'est gagné !</div>"
      $( "#laReunion" ).fireworks()
      $( ".echelle" ).draggable( "destroy" )
      $( "#mafate" ).sortable( "destroy" )
      climbAndJump()
      $( ".level[data-level='#{CURRENT_LEVEL}']" ).addClass "green"
      delay 5000, -> $( "#parametres" ).show()

  draw = ->
    $( "#mafate, #echelles" ).empty()
    
    for i in ILETS
      ilet = new Ilet(i)
      $( "#mafate" ).append ilet.html
      $( ".ilet[data-altitude='#{ilet.altitude}']" ).css height: "#{50*i}px"   
    height = $( "#mafate .ilet:first" ).attr "data-altitude"
    $( "#riveG" ).css 
      backgroundSize: "100px #{height*50}px"
      backgroundPosition: "bottom"   
    $( ".spot:first .ilet" ).append "<div id='facteur'></div>"  
    $( "#facteur" ).css top: "-50px", left: "40%"
    height = $( "#mafate .ilet:last" ).attr "data-altitude"  
    h = $( ".spot:last" ).height()-height*50
    $( ".spot:last" ).css background: "url(css/images/case.png) no-repeat", backgroundPosition: "5px #{h-50}px"
    $( "#riveD" ).css backgroundSize: "100px #{height*50}px", backgroundPosition: "bottom"     
     
    for i in ECHELLES
      echelle = new Echelle(i)
      $( "#echelles" ).append echelle.html
      echelle = $( ".echelle[data-hauteur='#{echelle.hauteur}']" )
      mini echelle 
    $( "#mafate" ).sortable
      items: '.spot:not(:first, :last)'
      stop: -> 
        $( ".spot:first .ilet" ).append $( "#facteur" )
        checkit()
       
    $( "#echelles" ).draggable containment: "#laReunion"
    $( ".echelle" ).draggable
      helper: "clone"
      appendTo: "body"
      revert: (valid_drop) -> if not valid_drop and $(this).parent().is( "#echelles" ) then mini $(this) else true
      start : (event, ui) -> 
        ui.helper.css('z-index', "10")
        maxi ui.helper

    $( "#echelles, #mafate" ).droppable
      tolerance : 'touch'        
      accept    : '.echelle'    
      drop: ( event, ui ) ->
        ui.helper.remove()
        $( "#echelles"  ).append ui.draggable
        mini ui.draggable
            
    $( ".via" ).droppable
      tolerance : 'touch'        
      accept    : (d) -> return d.is( ".echelle" ) and $(this).is( ":empty" )
      activeClass : "shine-yellow"
      hoverClass  : "shine-white"
      drop: ( event, ui ) ->
        ui.helper.remove()
        viaHeight = Math.abs parseInt($(this).attr "data-denivelle")
        scaleHeight = parseInt(ui.draggable.attr "data-hauteur")
        current_scale = $( this ).find( ".echelle" )
        if viaHeight is scaleHeight
          $(this).append ui.draggable
          maxi ui.draggable
          if current_scale.length
            $( "#echelles"  ).append current_scale
            mini current_scale       
          checkit()
        else
          ui.draggable.draggable 'option','revert', -> 
            if $(this).parent().is( "#echelles" )
              mini $(this)
            return true
         
  random = (n) ->
    [ECHELLES, ILETS] = [ [], [ Math.floor(Math.random() * 10) + 1 ] ]
    [lop, k] = [true, 0]
    while (lop and (k<1000))
      [lop, k] = [false, k+1]
      for i in [0..n-1]
        e = []
        for j in [-10..10]
          c = ILETS[i] + j
          if not ( (j is 0) or (Math.abs(j) in ECHELLES) or (c not in [1..10]) or (c in ILETS) )
            e.push j
        if e.length
          elu = (e.shuffle())[0]
          ECHELLES.push Math.abs(elu)
          ilet = ILETS[i] + elu
          ILETS.push( ilet )
        else
          lop = true
          break       
    SOLUTION = ILETS.slice(0)
    ILETS = SOLUTION.slice(0)
    first = ILETS.shift()
    last = ILETS.pop()
    ILETS.shuffle()
    ILETS = [first].concat( ILETS ).concat [last]
    ECHELLES.shuffle()
    draw()
    checkit()
  
  $( "#amount-slider" ).html("7")         
  $( "#slider" ).slider
    range: "max"
    min   : 2
    max   : 7
    step  : 1
    value : 6
    slide : ( event, ui ) ->
      $( "#gagne" ).remove()
      $( "#laReunion" ).fireworks( 'destroy' )
      $( "#amount-slider" ).html( ui.value )
      random(n = parseInt $( "#amount-slider" ).html() )
   
  $( ".level" )
    .button()
    .on "click", ->
      $( "#parametres" ).hide()
      level = parseInt $(this).attr( "data-level" )
      $( "#gagne" ).remove()
      $( "#laReunion" ).fireworks( 'destroy' )
      SOLUTION = CHALLENGES[level].ilets
      ECHELLES = CHALLENGES[level].echelles.shuffle()
      ILETS = SOLUTION.slice(0)
      [first, last] = [ILETS.shift(), ILETS.pop()]
      ILETS = [first].concat( ILETS.shuffle() ).concat [last]
      SOLUTION = []
      CURRENT_LEVEL = level
      draw()
      checkit()
  
  $( "#close" ).button().on "click", -> $( "#parametres" ).hide()
      
  $( "#random" ).button()
    .on "click", ->
      $( "#gagne" ).remove()
      $( "#laReunion" ).fireworks( 'destroy' )
      random( n = parseInt $( "#amount-slider" ).html() )
      
  $( "#solution" )
    .button()
    .on "click", ->
      ILETS = SOLUTION if SOLUTION.length > 0
      draw()
      checkit()
  
  $( ".more" ).button().on "click", -> $( "#more" ).show()
  
  $( ".level[data-level='1']" ).trigger "click"
  $( "#param_button" ).trigger "click"
  

