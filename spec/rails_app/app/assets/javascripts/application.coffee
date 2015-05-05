#= require jquery
#= require turbolinks
#= require dynamic-fields-for

$(document).on 'dynamic-fields:after-add', (e)->
  $('#event_catcher').append("dynamic-fields:after-add : #{e.target.className}<br />")

$(document).on 'dynamic-fields:before-remove', (e)->
  $('#event_catcher').append("dynamic-fields:before-remove : #{e.target.className}<br />")
