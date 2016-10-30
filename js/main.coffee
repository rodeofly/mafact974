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
        current_alt = parseInt $(this).find( ".ilet" ).attr( "data-altitude" )
        next_alt = parseInt $(this).next(".spot").find( ".ilet" ).attr( "data-altitude" )
        d = current_alt - next_alt
        height = "#{Math.abs(d)}0%"    
        if (d > 0)
          bottom = "#{next_alt}0%"
        else
          bottom = "#{current_alt}0%"
        via
          .attr "data-denivelle", d
          .css
            'height': height
            'bottom': bottom
            'bottom': bottom
        echelle  = parseInt( via.find( ".echelle" ).attr("data-hauteur") )
        if echelle isnt Math.abs(current_alt - next_alt)
          via.find( ".echelle" ).addClass( "shine-wrong" )
        else
          via.find( ".echelle" ).addClass( "shine-right" )
    $( ".spot" ).last().find( ".echelle" ).appendTo( "#echelles" )
    $( ".spot" ).last().find(".via").hide()
    
    blues = $( ".shine-right" ).length
    ech = $( ".echelle" ).length
    alert "gagné !" if ech is blues
     
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
    dice = Math.floor(Math.random() * 10) + 1
    ilets = [ dice ]
    e = [-10..10]
    lop = true
    k = 0
    while (lop and (k<100000))
      lop = false
      k++
      for i in [0..n-2]
        e = [-10..10]
        for j in [-10..10]
          c = ilets[i] + j
          if ( (j is 0) or (Math.abs(j) in echelles) or (c > 10) or (c < 1) or (c in ilets) )
            index = e.indexOf(j)
            e.splice(index, 1)
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

