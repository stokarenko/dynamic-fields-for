$.fn.extend
  find2: (selector) ->
    @.filter(selector).add(@.find(selector))

class DynamicFields
  @_counter = 0

  @add: (element) ->
    @_find($(element).data('dynamicFieldsAdd')).add()

  @remove: (element) ->
    @_find($(element).data('dynamicFieldsRemove')).remove($(element))

  @_find: (fields_id) ->
    object = @_$anchor('begin', fields_id)
    element = object.get(0)
    element.lazy_dynamic_fields ||= new @ object

  @_anchor: (postfix, fields_id) ->
    "[data-dynamic-fields-#{postfix}=#{fields_id}]"

  @_$anchor: (postfix, fields_id) ->
    $(@_anchor(postfix, fields_id))

  constructor: ($fields_begin) ->
    @fields_id = $fields_begin.data('dynamicFieldsBegin')

    @$fields_begin = $fields_begin
    @$fields_end = @_$anchor('end')

  add: ->
    fields_add = $(@_render_insertion('Add'))

    @$fields_end.before(fields_add)
    fields_add.not('script').trigger('dynamic-fields:add')

  remove: ($element) ->
    node = $element
    while (fields_item_begin = node.prevAll("#{@_anchor('item-begin')}:first"); fields_item_begin.length == 0)
      node = node.parent()
      break if node.length == 0

    return if fields_item_begin.length == 0

    if (object_id = $element.data('dynamicFieldsRemoveId'))
      destroy_inputs = @_render_insertion('Remove').replace(
        /(["])dynamic_fields_object_id(["])/g,
        "$1#{object_id}$2"
      )
      @$fields_begin.after(destroy_inputs)

    fields_remove = fields_item_begin.
      nextUntil("#{@_anchor('item-begin')}, #{@_anchor('end')}").
      andSelf()

    fields_remove.not('script').trigger('dynamic-fields:remove')
    fields_remove.remove()

  _anchor: (postfix) ->
    @constructor._anchor(postfix, @fields_id)

  _$anchor: (postfix) ->
    @constructor._$anchor(postfix, @fields_id)

  _render_insertion: (template_type) ->
    template = @$fields_begin.data("dynamicFields#{template_type}Template")
    template.replace(
      /([_\[])dynamic_fields_index([_\]])/g,
      "$1#{new Date().getTime() + @constructor._counter++}$2"
    )

$(document).on 'click', '[data-dynamic-fields-remove]', (event) ->
  event.preventDefault()
  DynamicFields.remove(@)

$(document).on 'click', '[data-dynamic-fields-add]', (event) ->
  event.preventDefault()
  DynamicFields.add(@)
