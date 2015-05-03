module DynamicFieldsFor
  module FormHelper
    extend ActiveSupport::Concern

    included do
      alias_method_chain :fields_for_nested_model, :dynamic_fields
    end

    def dynamic_fields_for(association, record_object = nil, options = {}, &block)
      options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?

      options.merge!(dynamic_fields: true)

      collection_output = fields_for(association, record_object, options, &block)
      new_output = fields_for(association, @object.send(association).soft_build, options.merge(child_index: 'dynamic_fields_index'), &block)

      dynamic_fields_id = "#{self.object_id}-#{association}"

      @template.content_tag(:script, nil, data: {
        'dynamic-fields-begin' => dynamic_fields_id,
        'dynamic-fields-template' => CGI.escapeHTML(new_output).html_safe
      }) +
      collection_output +
      @template.content_tag(:script, nil, data: {
        'dynamic-fields-end' => dynamic_fields_id
      })
    end

    def dynamic_fields_add_link(association, label, options = {})
      @template.link_to(label, '#', {data: {'dynamic-fields-add' => "#{self.object_id}-#{association}"}}.deep_merge(options))
    end

    def dynamic_fields_remove_link(label, options = {})
      destroy_input = @object.try(:persisted?) ?
        hidden_field(:_destroy) :
        ''
      destroy_input.html_safe + @template.link_to(label, '#', {data: {'dynamic-fields-remove' => true}}.deep_merge(options))
    end

    def fields_for_nested_model_with_dynamic_fields(name, object, fields_options, block)
      output = fields_for_nested_model_without_dynamic_fields(name, object, fields_options, block)
      return output unless fields_options[:dynamic_fields]

      @template.content_tag(:script, nil, data: {
        'dynamic-fields-item-begin' => true
      }) + output
    end

  end
end
