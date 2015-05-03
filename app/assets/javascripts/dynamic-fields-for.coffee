$(document).on 'ready page:load', ->
  dynamic_fields_counter = 0

  prepareDynamicFieldsRemove = (parent) ->
    parent ||= $('body')

    parent.find('[data-dynamic-fields-remove]').each (i, el) ->
      $(el).on 'click', (event) ->
        event.preventDefault()
        fieldset = $(el).closest("[data-dynamic-fields-item]")
        destroy_input = $(el).prev()
        if (/\[_destroy\]/i.test(destroy_input.attr('name')))
          destroy_input.val(true)
          fieldset.hide()
        else
          fieldset.remove()

  $('[data-dynamic-fields-add]').each (i, el) ->
    $(el).on 'click', (event) ->
      event.preventDefault()
      fieldset = $("[data-dynamic-fields=#{$(el).data('dynamicFieldsAdd')}]")
      template = fieldset.data('dynamicFieldsTemplate').replace(
        /dynamic_fields_index/g,
        new Date().getTime() + dynamic_fields_counter++
      )
      fieldset.append(template)
      prepareDynamicFieldsRemove(fieldset.children().last())

  prepareDynamicFieldsRemove()
