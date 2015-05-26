(function() {
  var DynamicFields;

  $.fn.extend({
    find2: function(selector) {
      return this.filter(selector).add(this.find(selector));
    }
  });

  DynamicFields = (function() {
    DynamicFields._counter = 0;

    DynamicFields.add = function(element) {
      var lazy_dynamic_fields;
      lazy_dynamic_fields = this._find($(element).data('dynamicFieldsAdd'));
      if (lazy_dynamic_fields) {
        return lazy_dynamic_fields.add();
      }
    };

    DynamicFields.remove = function(element) {
      var lazy_dynamic_fields;
      lazy_dynamic_fields = this._find($(element).data('dynamicFieldsRemove'));
      if (lazy_dynamic_fields) {
        return lazy_dynamic_fields.remove($(element));
      }
    };

    DynamicFields._find = function(fields_id) {
      var $fields_begin, fields_begin;
      $fields_begin = this._$anchor('begin', fields_id);
      fields_begin = $fields_begin.get(0);
      if (!fields_begin) {
        return null;
      }
      return fields_begin.lazy_dynamic_fields || (fields_begin.lazy_dynamic_fields = new this($fields_begin));
    };

    DynamicFields._anchor = function(postfix, fields_id) {
      return "[data-dynamic-fields-" + postfix + "=" + fields_id + "]";
    };

    DynamicFields._$anchor = function(postfix, fields_id) {
      return $(this._anchor(postfix, fields_id));
    };

    function DynamicFields($fields_begin) {
      this.fields_id = $fields_begin.data('dynamicFieldsBegin');
      this.$fields_begin = $fields_begin;
      this.$fields_end = this._$anchor('end');
      this.$fields_parent = this.$fields_begin.parent();
    }

    DynamicFields.prototype.add = function() {
      var fields_add;
      fields_add = $($.parseHTML(this._render_insertion('Add'), null, true));
      this.$fields_parent.trigger('dynamic-fields:before-add-into');
      this.$fields_end.before(fields_add);
      fields_add.not('script').trigger('dynamic-fields:after-add');
      return this.$fields_parent.trigger('dynamic-fields:after-add-into');
    };

    DynamicFields.prototype.remove = function($element) {
      var all_fields, destroy_inputs, fields_item_begin, fields_remove, index_begin, index_end, node, object_id;
      node = $element;
      while ((fields_item_begin = node.prevAll((this._anchor('item-begin')) + ":first"), fields_item_begin.length === 0)) {
        node = node.parent();
        if (node.length === 0) {
          break;
        }
      }
      if (fields_item_begin.length === 0) {
        return;
      }
      if ((object_id = $element.data('dynamicFieldsRemoveId'))) {
        destroy_inputs = this._render_insertion('Remove').replace(/(["])dynamic_fields_object_id(["])/g, "$1" + object_id + "$2");
        this.$fields_begin.after(destroy_inputs);
      }
      all_fields = this.$fields_parent.contents();
      index_begin = all_fields.index(fields_item_begin);
      index_end = all_fields.index(fields_item_begin.nextAll((this._anchor('item-begin')) + ", " + (this._anchor('end'))).first());
      fields_remove = all_fields.slice(index_begin, index_end);
      this.$fields_parent.trigger('dynamic-fields:before-remove-from');
      fields_remove.not('script').trigger('dynamic-fields:before-remove');
      fields_remove.remove();
      return this.$fields_parent.trigger('dynamic-fields:after-remove-from');
    };

    DynamicFields.prototype._anchor = function(postfix) {
      return this.constructor._anchor(postfix, this.fields_id);
    };

    DynamicFields.prototype._$anchor = function(postfix) {
      return this.constructor._$anchor(postfix, this.fields_id);
    };

    DynamicFields.prototype._render_insertion = function(template_type) {
      var template;
      template = this.$fields_begin.data("dynamicFields" + template_type + "Template");
      return template.replace(/([_\[])dynamic_fields_index([_\]])/g, "$1" + (new Date().getTime() + this.constructor._counter++) + "$2");
    };

    return DynamicFields;

  })();

  $(document).on('click', '[data-dynamic-fields-remove]', function(event) {
    event.preventDefault();
    return DynamicFields.remove(this);
  });

  $(document).on('click', '[data-dynamic-fields-add]', function(event) {
    event.preventDefault();
    return DynamicFields.add(this);
  });

}).call(this);
