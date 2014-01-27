$ ->
  ###
    Index
  ###
  search_form = $('#search_form')
  #Query for infinite scroll
  search_query = search_form.serialize()

  #Set select2 dropdowns
  $("#sort_by").select2    placeholder: "Sort By",  allowClear: true
  $("#gender").select2     placeholder: "Gender",   allowClear: true
  $("#language").select2   placeholder: "Language", allowClear: true
  $("#age_group").select2  placeholder: "Age",      allowClear: true
  $("#interest").select2   placeholder: "Do",       allowClear: true

  update_guide_showing_count()

  #Search on filter change - empty cards
  $("#sort_by, #gender, #language, #age_group, #interest").change ->
    $(".guide_cards").empty();
    search_form.submit()

  # Infinite scroll for guides page
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next>a').attr('href')
      if url && close_to_bottom(400)
        #Prevent from loading occuring multiple times
        $('.paginator').text("Fetching more guides...")
        action       = search_form.attr('action')
        search_query = search_form.serialize()
        page_param   = /page=(\d+)/i.exec(url)[0]
        query        = "#{action}?#{search_query}&#{page_param}"
        $.getScript(query)
    $(window).scroll()

close_to_bottom = (margin) ->
  $(window).scrollTop() > $(document).height() - $(window).height() - margin

update_guide_showing_count = ->
  $('#showing_count').text($('.guide_card').length)
window.update_guide_showing_count = update_guide_showing_count

update_guide_total_count = (total_count) ->
  $('#total_count').text(total_count)
window.update_guide_total_count = update_guide_total_count

$ ->
  ###
    Show
  ###
  #rating star click handler: set rating hidden field
  thumbs_handler = (e) ->
    id = $(e.target).attr('id')
    switch id
      when "new_positive_rating" then set_thumbs_by_rating 1
      when "new_negative_rating" then set_thumbs_by_rating -1

  window.thumbs_handler = thumbs_handler

  $('#new_comment_stars>div').click (e) -> 
    thumbs_handler(e)

  set_thumbs_by_rating = (rating_val) ->    
    thumbs_up   = $('#new_positive_rating')
    thumbs_down = $('#new_negative_rating')

    remove_thumbs_selection()
    # set hidden field
    $('#rating').val rating_val
    if rating_val is 1
      thumbs_up.removeClass 'thumbs_up_empty'
      thumbs_up.addClass 'thumbs_up_full'     
    else if rating_val is -1
      thumbs_down.removeClass 'thumbs_down_empty'
      thumbs_down.addClass 'thumbs_down_full'

  window.set_thumbs_by_rating = set_thumbs_by_rating

  set_thumbs_by_rating 1

clear_new_comment_box = ->
  $('#comment_body').val("")
  $('#rating').val 0  

remove_thumbs_selection = ->
  thumbs_up   = $('#new_positive_rating')
  thumbs_down = $('#new_negative_rating')

  thumbs_up.removeClass()
  thumbs_down.removeClass()
  thumbs_up.addClass 'thumbs_up_empty'
  thumbs_down.addClass 'thumbs_down_empty'  

$ ->
  ###
    Edit
  ###
  update_remaining_short_introduction_length = ->
    short_introduction_area = $('#guide_short_introduction')
    if short_introduction_area.length > 0
      length_label   = $('#short_introduction_remaining_length')
      current_length = short_introduction_area.val().length
      length_label.text(200 - current_length)

  select2_for_languages = ->
    $('select[name*="guide[spoken_languages_attributes]"]').select2()    

  $('#guide_short_introduction').on 'keyup', ->
    update_remaining_short_introduction_length()

  update_remaining_short_introduction_length()

  # JS to add and remove languages
  $('#save_guide_form').nestedFields({
    beforeRemove: (item, action) ->
      if $('#spoken_language_items>fieldset:visible').length > 1
        action()
      else
        alert 'You need to have at least one language!'
    afterInsert: (item, action) ->
      item.find('select').select2()
  })

  validate_form = ->
    valid                        = true
    city                         = $('#new_guide_city_search')
    city_length                  = city.val().length
    short_intro                  = $('#guide_short_introduction')
    short_intro_length           = short_intro.val().length
    guide_rate                   = $('#guide_rate')
    guide_rate_length            = guide_rate.val().length
    transportation_methods_div   = $('#transportation_methods_div')
    checked_trans_methods_length = $('input[name="guide[transportation_method_ids][]"]:checkbox:checked').length
    services_div                 = $('#services_div')
    checked_services_length      = $('input[name="guide[service_ids][]"]:checkbox:checked').length
    guide_interests_div          = $('#guide_interests_div')
    checked_interests_length     = $('input[name="guide[interest_ids][]"]:checkbox:checked').length

    elements_to_validate = [
      [city_length,                  city],
      [short_intro_length,           short_intro],
      [guide_rate_length,            guide_rate],
      [checked_trans_methods_length, transportation_methods_div],
      [checked_services_length,      services_div],
      [checked_interests_length,     guide_interests_div]
    ]

    $('.required-message').remove()
    
    for e in elements_to_validate
      if e[0] < 1
        valid = false
        e[1].addClass('error')
        required_message = '<div class="required-message">Field is required</div>'
        if e[1].is("div")
          e[1].prepend(required_message)
        else
          e[1].before(required_message)
      else
        e[1].removeClass('error')

    $('html, body').animate({scrollTop: $(".error").offset().top-100}, 500) if $(".error").length > 0
    valid

  select2_for_languages()

  $('#save_guide_form').submit ->
    validate_form()