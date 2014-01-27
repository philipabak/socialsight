$ ->
  if $("#city_search").length > 0
    options = 
      types: ['(cities)']
      #componentRestrictions: {country: "hu"}
    input = $('#city_search')[0]
    autocomplete = new google.maps.places.Autocomplete input, options