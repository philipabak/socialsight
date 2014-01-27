# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $(".need-booking-data-label").parent().bind('click', showBookingDataRow)

showBookingDataRow = (e)->
  if  e.target.tagName.toUpperCase()!="TD"
    $(".booking-data-row").toggleClass("hidden")