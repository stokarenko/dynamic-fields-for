#= require jquery
#= require turbolinks
#= require dynamic-fields-for

$(document).on '
dynamic-fields:before-add-into
dynamic-fields:after-add
dynamic-fields:after-add-into
dynamic-fields:before-remove-from
dynamic-fields:before-remove
dynamic-fields:after-remove-from
', (e)->
  $('#event_catcher').append("#{e.type} : #{e.target.className || 'id'}<br />")
