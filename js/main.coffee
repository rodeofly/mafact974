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


audioElement = document.createElement('audio');
audioElement.setAttribute('src', 'sounds/maloya-fast.wav');
audioElement.load()
#audioElement.addEventListener('ended', () -> 
#  this.currentTime = 0
#  this.play()
#, false)




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
      diveornot = () ->
        offset = $( "#facteur" ).offset()
        altimetre =  (parseInt($( "#laReunion" ).height()) - parseInt(offset.top)) + 50
        console.log "altimetre = #{altimetre}"
        if altimetre < 0
          $( "#facteur" ).addClass "dive"
        else
          console.log "undive"
          $( "#facteur" ).removeClass "dive"

      diveornot()
      parent = $( "#facteur" ).parent()
      if parent.hasClass "ilet"
        #console.log "in ilet"
        via = parent.siblings ".via:first()"

        if via.find( ".echelle").length > 0 
          delay delai, -> 
            d = parseInt via.attr( "data-denivelle" )
            via.find( ".echelle").append $( "#facteur")
            i = Math.abs d         
            altitude = parseInt $( "#facteur" ).closest( ".spot" ).next(".spot").find( ".ilet" ).attr( "data-altitude" )
            
            
                      
            switch d>0
              
              when true
                if altitude < 0
                  console.log "echelle descend vers le négatif"
                  $( "#facteur" ).css top: "-50px", bottom: "auto", left: "40%"
                else
                  console.log "echelle descend vers le positif"
                  $( "#facteur" ).css top: "-50px", bottom: "auto", left: "40%"
                climbAndJump(1, i)
              else
                if altitude < 0
                  console.log "echelle monte vers le négatif"
                  $( "#facteur" ).css top: "auto", bottom: "0px", left: "40%"
                else
                  console.log "echelle monte vers le positif"
                  $( "#facteur" ).css top: "auto", bottom: "0px", left: "40%"
                climbAndJump(-1, i) 
        else
          if $( "#facteur" ).closest( ".spot" ).is $( ".spot:last")
            if altitude < 0
              $( "#facteur" ).css top: "auto", bottom: "0px", left: "40%"
             
            $( "#facteur" ).addClass "pause"
            audioElement.play()
      else
        # console.log "in echelle"
        altitude = parseInt $( "#facteur" ).closest( ".spot" ).next(".spot").find( ".ilet" ).attr( "data-altitude" )
        if i
          i--
          alt = parseInt $( "#facteur" ).css( "top" )
          delay delai, ->
            if altitude < 0
              $( "#facteur" ).css top: "#{alt+c*50}px"
            else
              $( "#facteur" ).css top: "#{alt+c*50}px"
            climbAndJump(c, i)
        else
          #console.log "in da flood #{altitude}"
          ilet = $( "#facteur" ).closest( ".spot" ).next(".spot").find( ".ilet" )
          delay delai, -> 
            ilet.append $( "#facteur" )
            
            if altitude < 0
              $( "#facteur" ).css
                top: "#{ilet.height()-50}px"
                left: "40%"

            else
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
      ilet =$( ".ilet[data-altitude='#{ilet.altitude}']" )
      ilet.css 
        height: "#{50*Math.abs(i)}px"  
        backgroundPosition: "5px #{h-50}px"
      if i<0
        ilet.css 
          bottom : "#{50*i}px"
          background: "#c6c4f1 url(images/strate.png) repeat"
        ilet.find( ".info").css bottom: "0px"
      else
        ilet.css 
          bottom : "0px"
    
    $( ".ilet" ).first().addClass "first-ilet"
    $( ".ilet" ).last().addClass "last-ilet"
    f = parseInt $( ".first-ilet" ).attr( "data-altitude" )
    l = parseInt $( ".last-ilet" ).attr( "data-altitude" )
    if f < 0
      $( ".first-ilet" ).css
        background: "#1007cb url(images/strate.png) repeat"
      $( ".first-ilet" ).find( ".info").css color: "white"
    if l < 0
      $( ".last-ilet" ).css
        background: "#1007cb url(images/strate.png) repeat"
      $( ".last-ilet" ).find( ".info").css color: "white"
   
        
        
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

    $( ".echelle" ).on "dblclick", ->
            current_scale = $(this)
            scale_height = current_scale.data('hauteur')
            for via in $("#mafate").find(".via[data-denivelle!=0]")
                if $(via).find('.echelle').length
                    continue
                if Math.abs( $(via).data( "denivelle" ) ) == scale_height
                    $(via).append current_scale
                    maxi current_scale
                    checkit()
                    break

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
    
    
  
  # Returns a random number between min (inclusive) and max (exclusive)
  randFloat = (min, max) -> return Math.random() * (max - min) + min

  # Returns a random integer between min (inclusive) and max (inclusive)
  randint = (min, max) -> return Math.floor(Math.random() * (max - min + 1)) + min

  random = (n) ->
    #xz est l'altitude du premier Ilet et (n+1) est le nombre total d'Ilet
    genere = (xz,n) -> 
      #on genere epsilon : liste d'entiers valant -1 ou 1
      epsilon = []
      epsilon.push(2*randint(0,1)-1) for k in [1..n+1]
      console.log "epsilon = #{epsilon}"
      #on genere une "permutation" tau
      tau = [1..n+1].shuffle()
      console.log "tau = #{tau}"  
      #on genere y
      y = [xz]
      y.push( y[k]+epsilon[k]*tau[k] ) for k in [0..n]         
      console.log "y = #{y}"
      #on genere la permutation sigma
      sigma = [0]
      sigma.push(k) for k in [1..n+1].shuffle()
      console.log "sigma = #{sigma}"
      #on genere x
      x=[xz]
      x.push( y[sigma[k]] ) for k in [1..n]  
      x[n+1] = y[n+1]
      console.log "x = #{x}"
      
      SOLUTION = y
    
    genere(randint(1,n), n)
    ECHELLES = ( k for k in [1..n+1].shuffle())     
    ILETS = SOLUTION
    [first, last] = [ILETS.shift(), ILETS.pop()]
    ILETS.shuffle()
    ILETS = [first].concat( ILETS ).concat [last]
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
  

