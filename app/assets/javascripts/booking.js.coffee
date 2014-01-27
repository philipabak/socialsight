# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.booking_completed_link').click (e) =>
    e.preventDefault()
    booking_link = $(e.target).attr("href")
    # submit booking
    $.ajax booking_link,
      type: 'GET'
      dataType: 'html'
      success: (data, textStatus, jqXHR) ->
        response = jQuery.parseJSON(data)
        answer = confirm "#{response.text}"
        if answer
          window.location = response.go_url;
        else
          window.location = response.stay_url;