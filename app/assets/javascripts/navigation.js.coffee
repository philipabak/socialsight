$(document).ready ->
  options = 
    types: ['(cities)']

  if $("#global_city_search").length > 0
    input = $('#global_city_search')[0]
    autocomplete1 = new google.maps.places.Autocomplete input, options
    google.maps.event.addListener autocomplete1, 'place_changed', ->
      place   = autocomplete1.getPlace()
      if place.address_components?
        window.location.href = "/city_search?city_search=#{place.formatted_address}"
      else
        return false

  if $("#new_guide_city_search").length > 0
    input = $('#new_guide_city_search')[0]
    autocomplete = new google.maps.places.Autocomplete input, options
    google.maps.event.addListener autocomplete, 'place_changed', ->
      place = autocomplete.getPlace()
      if place.address_components?
        ac = place.address_components
        $.each ac, (i, address_component) ->
          $("#city_country_name").val address_component.long_name  if address_component.types[0] is "country"
          
        $('#city_name').val(ac[0].long_name)
        $('#city_longitude').val(place.geometry.location.lng())
        $('#city_latitude').val(place.geometry.location.lat())
      else
        $('#city_name').val("")
        $('#city_country_name').val("")
        $('#city_longitude').val("")
        $('#city_latitude').val("")

  #Disable enter on joinus form      
  $("#new_user, #new_guide_city_search").keypress (e) ->
    return false if e.keyCode is 13

  #Js login handler
  $('#loginform').on "ajax:complete", (event, data, status, xhr) ->
    response = jQuery.parseJSON(data.responseText);
    if response.result=='success'
      window.location = response.url;
    else
      $('#login_msg').html '<div class="alert alert-error invalid-pass">'+response.msg+'</div>'