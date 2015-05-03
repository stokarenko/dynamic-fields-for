$(document).on 'ready page:load', ->
  dynamic_fields_counter = 0

  $('[data-dynamic-fields-add]').each (i, el) ->
    $(el).on 'click', (event) ->
      event.preventDefault()
      fieldset = $("[data-dynamic-fields=#{$(el).data('dynamicFieldsAdd')}]")
      template = fieldset.data('dynamicFieldsTemplate').replace(
        /dynamic_fields_index/g,
        new Date().getTime() + dynamic_fields_counter++
      )
      fieldset.append(template)
