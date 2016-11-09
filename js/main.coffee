Array::shuffle ?= ->
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor( Math.random() * (i + 1) )
    [@[i], @[j]] = [@[j], @[i]]
  this

ID = 1
SOLUTION = [1,2,10,3,9,4,8,5]
ILETS = SOLUTION.slice(0).shuffle()
ECHELLES = [1,3,4,5,6,7,8]

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
  $( "#parametres" ).dialog
    width : '800px'
    position: {my: 'center bottom', at: 'center bottom', of: window}
    
  $( "#param_button" )
    .button()
    .on "click", -> $( "#parametres" ).dialog( "open" )
    
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
        via
          .attr "data-denivelle", deniv
          .css
            'height': "#{height}0%"
            'bottom': bottom
          .show()    
        if via.find( ".echelle" ).length > 0
          scale  = parseInt( via.find( ".echelle" ).attr("data-hauteur") )
          console.log scale,height
          if scale is height
            via.find( ".echelle" ).addClass "shine-right"
          else via.find( ".echelle" ).addClass "shine-wrong" 
      else
        scale = via.find( ".echelle" )
        scale.appendTo( "#echelles" )
        scale.css position: "relative"
        via.hide()
    bleues = $( ".shine-right" ).length
    scales = $( ".echelle" ).length
    if bleues is scales
      $( "#echelles" ).append "<div id='gagne'>Oté, c'est gagné !</div>"
      $( "body" ).fireworks()
     
  draw = ->
    $( "#mafate, #echelles" ).empty()
    for i in ILETS
      ilet = new Ilet(i)
      $( "#mafate" ).append ilet.html
      $( ".ilet[data-altitude='#{ilet.altitude}']" ).css 'height': "#{50*i}px"
      
    for i in ECHELLES
      echelle = new Echelle(i)
      $( "#echelles" ).append echelle.html
      $( ".echelle[data-hauteur='#{echelle.hauteur}']" ).css 'height': "#{50*i}px" 
    
    $( "#mafate" ).sortable
      stop: -> checkit()
     
    $( "#echelles" ).draggable
      containment: "body"
    $( ".echelle" ).draggable
      revert : true
    
    $( ".via" ).droppable
      tolerance : 'touch'        
      accept    : '.echelle'    
      activeClass : "shine-yellow"
      hoverClass  : "shine-white"
      drop: ( event, ui ) ->
        current_scale = $( this ).find( ".echelle" )
        if current_scale.length
          $( "#echelles"  ).append current_scale
          current_scale.css position: "relative"
        $(this).append ui.draggable
        ui.draggable.css
          position: 'absolute'
          left : 0
          bottom : 0
          top: ''
        checkit()
     
  go = ->
    n = parseInt $( "#amount-slider" ).html()
    [ECHELLES, ILETS] = [ [], [ Math.floor(Math.random() * 10) + 1 ] ]
    [lop, k] = [true, 0]
    while (lop and (k<1000))
      [lop, k] = [false, k+1]
      for i in [0..n-2]
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
    ILETS.shuffle()
    ECHELLES.shuffle()
    draw()
    checkit()
  
  $( "#amount-slider" ).html("7")         
  $( "#slider" ).slider
    range: "max"
    min   : 2
    max   : 8
    step  : 1
    value : 7
    slide : ( event, ui ) -> 
      $( "#amount-slider" ).html( ui.value )
      go()
   
  $( "#random" )
    .button()
    .on "click", -> 
      $( "#gagne" ).remove()
      $( "body" ).fireworks( "destroy" )
      go()
  
  $( "#solution" )
    .button()
    .on "click", ->
      ILETS = SOLUTION
      draw()
      checkit()
 
  $( "#random" ).trigger "click"

