$.fn.extend
  find2: (selector) ->
    @.filter(selector).add(@.find(selector))

class DynamicFields
  @_counter = 0

  @add: (element) ->
    lazy_dynamic_fields = @_find($(element).data('dynamicFieldsAdd'))
    lazy_dynamic_fields.add() if lazy_dynamic_fields

  @remove: (element) ->
    lazy_dynamic_fields = @_find($(element).data('dynamicFieldsRemove'))
    lazy_dynamic_fields.remove($(element)) if lazy_dynamic_fields

  @_find: (fields_id) ->
    $fields_begin = @_$anchor('begin', fields_id)
    fields_begin = $fields_begin.get(0)
    return null unless fields_begin
    fields_begin.lazy_dynamic_fields ||= new @ $fields_begin

  @_anchor: (postfix, fields_id) ->
    "[data-dynamic-fields-#{postfix}=#{fields_id}]"

  @_$anchor: (postfix, fields_id) ->
    $(@_anchor(postfix, fields_id))

  constructor: ($fields_begin) ->
    @fields_id = $fields_begin.data('dynamicFieldsBegin')

    @$fields_begin = $fields_begin
    @$fields_end = @_$anchor('end')

    @$fields_parent = @$fields_begin.parent()

  add: ->
    fields_add = $(@_render_insertion('Add'))

    @$fields_parent.trigger('dynamic-fields:before-add-into')
    @$fields_end.before(fields_add)
    fields_add.not('script').trigger('dynamic-fields:after-add')
    @$fields_parent.trigger('dynamic-fields:after-add-into')

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

    @$fields_parent.trigger('dynamic-fields:before-remove-from')
    fields_remove.not('script').trigger('dynamic-fields:before-remove')
    fields_remove.remove()
    @$fields_parent.trigger('dynamic-fields:after-remove-from')

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
