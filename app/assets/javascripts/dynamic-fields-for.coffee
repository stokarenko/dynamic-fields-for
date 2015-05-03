$(document).on 'ready page:load', ->
  dynamic_fields_counter = 0

  $(document).on 'click', '[data-dynamic-fields-remove]', (event) ->
    event.preventDefault()

    node = $(this)

    while (fieldset = node.prevAll("[data-dynamic-fields-item-begin]:first"); fieldset.length == 0)
      node = node.parent()
      break if node.length == 0

    fieldset = fieldset.
      nextUntil('[data-dynamic-fields-item-begin], [data-dynamic-fields-end]').
      andSelf()
    destroy_input = $(this).prev()
    if (/\[_destroy\]/i.test(destroy_input.attr('name')))
      destroy_input.val(true)
      fieldset.hide()
    else
      fieldset.remove()

  $(document).on 'click', '[data-dynamic-fields-add]', (event) ->
    event.preventDefault()

    dynamic_fields_id = $(this).data('dynamicFieldsAdd')
    fieldset_begin = $("[data-dynamic-fields-begin=#{dynamic_fields_id}]")
    fieldset_end = $("[data-dynamic-fields-end=#{dynamic_fields_id}]")
    template = fieldset_begin.data('dynamicFieldsTemplate').replace(
      /dynamic_fields_index/g,
      new Date().getTime() + dynamic_fields_counter++
    )
    fieldset_end.before(template)
