#= require jquery
#= require turbolinks
#= require dynamic-fields-for

$(document).on 'dynamic-fields:add', (e)->
  $(e.target).find2('.add_event_catcher').html('add event catched')
