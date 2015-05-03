#= require jquery
#= require turbolinks
#= require dynamic-fields-for

$(document).on 'dynamic-fields:add', (e)->
  $(e.target).find2('.add_event_catcher').html('add event catched')

$(document).on 'dynamic-fields:remove', (e)->
  $('.remove_event_catcher').html($(e.target).find2('.role_name').val())
