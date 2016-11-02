Array::shuffle ?= ->
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [@[i], @[j]] = [@[j], @[i]]
  this

ID = 1
solution = [1,2,10,3,9,4,8,5]
ilets = solution.slice(0)
ilets.shuffle()
echelles = [1,3,4,5,6,7,8]

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
  checkit = -> 
    $( ".echelle" ).removeClass( "shine-right shine-wrong" )
    $( ".spot" ).each ->
      via = $(this).find( ".via" ).show()
      if $(this).next(".spot").length
        curr_alt = parseInt $(this).find( ".ilet" ).attr( "data-altitude" )
        next_alt = parseInt $(this).next(".spot").find( ".ilet" ).attr( "data-altitude" )
        deniv = curr_alt - next_alt
        height = "#{Math.abs(deniv)}0%"
        bottom = "#{if (deniv > 0) then next_alt else curr_alt}0%"
        via
          .attr "data-denivelle", deniv
          .css
            'height': height
            'bottom': bottom
            'bottom': bottom
        
        scale  = parseInt( via.find( ".echelle" ).attr("data-hauteur") )
        via.find( ".echelle" ).addClass( if scale isnt deniv then "shine-wrong" else "shine-right" )
    
    $( ".spot" ).last().find( ".echelle" ).appendTo( "#echelles" )
    $( ".spot" ).last().find(".via").hide()
    
    bleues = $( ".shine-right" ).length
    scales = $( ".echelle" ).length
    alert "gagné !" if bleues is scales
     
  draw = ->
    $( "#mafate, #echelles" ).empty()
    for i in ilets
      ilet = new Ilet(i)
      height = 50*i
      $( "#mafate" ).append ilet.html
      $( ".ilet[data-altitude='#{ilet.altitude}']" ).css
        'height': "#{height}px"
      
    for i in echelles
      echelle = new Echelle(i)
      height = 50*i
      $( "#echelles" ).append echelle.html
      $( ".echelle[data-hauteur='#{echelle.hauteur}']" ).css
        'height': "#{height}px" 
    
    $( "#mafate" ).sortable
      stop: -> checkit()
     
    $( "#echelles" ).draggable()
    $( ".echelle" ).draggable()
    
    $( ".via" ).droppable
      tolerance : 'touch'        
      accept    : '.echelle'    
      activeClass : "shine-yellow"
      hoverClass  : "shine-white"
      drop: ( event, ui ) ->   
        $(this).append ui.draggable
        ui.draggable.css
          position: 'absolute'
          left : 0
          bottom : 0
          top: ''
        checkit()   
          
  draw()
  checkit()
     
  go = ->
    n = parseInt $( "#amount-slider" ).html()
    echelles = []
    ilets = [ Math.floor(Math.random() * 10) + 1 ]
    [lop, k] = [true, 0]
    k = 0
    while (lop and (k<1000))
      lop = false
      k++
      for i in [0..n-2]
        e = []
        for j in [-10..10]
          c = ilets[i] + j
          if not (j is 0 or Math.abs(j) in echelles or c not in [1..10] or c in ilets )
            e.push j
        if e.length
          elu = (e.shuffle())[0]
          echelles.push Math.abs(elu)
          ilet = ilets[i] + elu
          ilets.push( ilet )
        else
          lop = true
          break
        
    solution = ilets.slice(0)
    ilets.shuffle()
    echelles.shuffle()
    draw()
    checkit()
        

  $( "#slider" ).slider
    range: "max"
    min   : 2
    max   : 10
    step  : 1
    value : 3
    slide : ( event, ui ) -> 
      $( "#amount-slider" ).html( ui.value )
      go()
        
  $( "#amount-slider" ).html("3")    
  
  $( "#random" )
    .button()
    .on "click", -> go()
  
  $( "#solution" )
    .button()
    .on "click", ->
      ilets = solution
      draw()
      checkit()

