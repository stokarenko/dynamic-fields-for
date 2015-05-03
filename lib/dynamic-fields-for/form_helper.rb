module DynamicFieldsFor
  module FormHelper
    def dynamic_fields_for(association, record_object = nil, options = {}, &block)
      collection_options = options.deep_dup
      collection_output = fields_for(association, record_object, collection_options, &block)
      new_output = fields_for(association, @object.send(association).soft_build, {child_index: 'dynamic_fields_index'}.merge(options), &block)

      @template.content_tag(:div, collection_output, data: {
        'dynamic-fields' => "#{self.object_id}-#{association}",
        'dynamic-fields-template' => CGI.escapeHTML(new_output).html_safe
      })
    end

    def dynamic_fields_add_link(association, label, options = {})
      @template.link_to(label, '#', {data: {'dynamic-fields-add' => "#{self.object_id}-#{association}"}}.deep_merge(options))
    end
  end
end
