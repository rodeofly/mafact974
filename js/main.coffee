Array::shuffle ?= ->
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor( Math.random() * (i + 1) )
    [@[i], @[j]] = [@[j], @[i]]
  this

ID = 1
SOLUTION = [] 
ILETS = []
ECHELLES = []

CHALLENGES =
  7:
    "ilets": [1,2,10,3,9,4,8,5]
    "echelles": [1,3,4,5,6,7,8]

class Ilet
  constructor: (@altitude) ->
    @html = """
    <div class='spot'>
        <div class='ilet' data-altitude='#{@altitude}'>
           <span class='info'>#{@altitude}</span>       
        </div>
        <div class='via' data-denivelle='0'></div>
    </div>
    """
    
class Echelle
  constructor: (@hauteur) ->
    @html = """
    <div class='echelle' data-hauteur='#{@hauteur}'>
      <span class='info'>#{@hauteur}</span>
    </div>
    """
  
$ ->
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
  
  
  html = "<div id='random'>Aléatoire</div><div id='solution'>Soluce</div><div id='close'>X</div>"
  html += "<div id='sliderInfo'>Niveaux :<span id='amount-slider'></span><div id='slider'></div></div><br><h2>Challenges</h2>"
  html += "<div class='level' data-level='#{i}'>#{i}</div>" for i in [7..7]
  $( "#parametres" ).append html
  $( "#parametres" ).draggable()
  $( "#param_button" ).button().on "click", -> $( "#parametres" ).toggle()
    
  checkit = -> 
    $( ".echelle" ).removeClass( "shine-right shine-wrong" )
    $( ".spot" ).each ->
      $next_spot = $(this).next(".spot")
      via = $(this).find( ".via" )         
      if $next_spot.length 
        curr_alt = parseInt $(this).find( ".ilet" ).attr( "data-altitude" )
        next_alt = parseInt $next_spot.find( ".ilet" ).attr( "data-altitude" )
        deniv = curr_alt - next_alt
        height = Math.abs(deniv)
        bottom = "#{if (deniv > 0) then next_alt else curr_alt}0%"
        via.attr("data-denivelle", deniv).css
          height: "#{height}0%"
          bottom: "#{bottom}"
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
    if bleues is scales
      $( "#echelles" ).append "<div id='gagne'>Oté, c'est gagné !</div>"
      $( "#mafate" ).fireworks()
     
  draw = ->
    $( "#mafate, #echelles" ).empty()
    for i in ILETS
      ilet = new Ilet(i)
      $( "#mafate" ).append ilet.html
      $( ".ilet[data-altitude='#{ilet.altitude}']" ).css height: "#{50*i}px"
      
    for i in ECHELLES
      echelle = new Echelle(i)
      $( "#echelles" ).append echelle.html
      echelle = $( ".echelle[data-hauteur='#{echelle.hauteur}']" )
      mini echelle
    
  
    
    $( "#mafate" ).sortable
      items: '.spot:not(:first, :last)'
      stop: -> checkit()
     
    $( "#echelles" ).draggable()
    $( ".echelle" ).draggable
      helper: "clone"
      appendTo: "body"
      revert: (valid_drop) ->
        if not valid_drop
          if $(this).parent().is "#echelles"
            mini $(this) 
        else true         
      start : (event, ui) -> 
        ui.helper.css('z-index', "10")
        maxi ui.helper


   
    $( ".via" ).droppable
      tolerance : 'touch'        
      accept    : '.echelle'    
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
      $( "#mafate" ).fireworks( 'destroy' )
      $( "#amount-slider" ).html( ui.value )
      random(n = parseInt $( "#amount-slider" ).html() )
   
  $( ".level" )
    .button()
    .on "click", ->
      $( "#parametres" ).hide()
      level = parseInt $(this).attr( "data-level" )
      $( "#gagne" ).remove()
      $( "#mafate" ).fireworks( 'destroy' )
      SOLUTION = CHALLENGES[level].ilets
      ECHELLES = CHALLENGES[level].echelles.shuffle()
      ILETS = SOLUTION.slice(0)
      [first, last] = [ILETS.shift(), ILETS.pop()]
      ILETS = [first].concat( ILETS.shuffle() ).concat [last]
      SOLUTION = []
      draw()
      checkit()
  
  $( "#close" ).button().on "click", -> $( "#parametres" ).hide()
      
  $( "#random" ).button()
    .on "click", ->
      $( "#gagne" ).remove()
      $( "#mafate" ).fireworks( 'destroy' )
      random( n = parseInt $( "#amount-slider" ).html() )
      
  $( "#solution" )
    .button()
    .on "click", ->
      ILETS = SOLUTION if SOLUTION.length > 0
      draw()
      checkit()
  
  $( "#random" ).trigger "click"
  $( "#param_button" ).trigger "click"
  
  

