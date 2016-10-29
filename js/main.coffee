ID = 1

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
  ilets = [1,2,3,4,5,8,9,10]
  echelles = [1,3,4,5,6,7,8]
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
    echelles = $( ".echelle" ).length
    alert "gagné !" if echelles is blues
    
      
          
    
  checkit()
     
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
        left : 0;
        top : 0;       
      checkit()

        
    
