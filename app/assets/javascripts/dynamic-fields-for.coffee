$(document).on 'ready page:load', ->
  dynamic_fields_counter = 0

  $(document).on 'click', '[data-dynamic-fields-remove]', (event) ->
    event.preventDefault()
    fieldset = $(this).closest("[data-dynamic-fields-item]")
    destroy_input = $(this).prev()
    if (/\[_destroy\]/i.test(destroy_input.attr('name')))
      destroy_input.val(true)
      fieldset.hide()
    else
      fieldset.remove()

  $(document).on 'click', '[data-dynamic-fields-add]', (event) ->
    event.preventDefault()
    fieldset = $("[data-dynamic-fields=#{$(this).data('dynamicFieldsAdd')}]")
    template = fieldset.data('dynamicFieldsTemplate').replace(
      /dynamic_fields_index/g,
      new Date().getTime() + dynamic_fields_counter++
    )
    fieldset.append(template)
