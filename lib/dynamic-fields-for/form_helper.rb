module DynamicFieldsFor
  module FormHelper
    extend ActiveSupport::Concern

    included do
      alias_method_chain :fields_for_nested_model, :dynamic_fields
    end

    def dynamic_fields_for(association, record_object = nil, options = {}, &block)
      #Inherit the native parameters adjustment
      options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?

      new_object = @object.send(association).soft_build

      options[:child_index] = 'dynamic_fields_index'
      remove_template = fields_for(association, new_object, options) do |f|
        f.hidden_field(:id, value: 'dynamic_fields_object_id') +
        f.hidden_field(:_destroy, value: true)
      end

      options[:dynamic_fields_id] = dynamic_fields_id(association)
      new_template = fields_for(association, new_object, options, &block)

      options.delete(:child_index)
      collection_output = fields_for(association, record_object, options, &block)

      @template.content_tag(:script, nil, data: {
        'dynamic-fields-begin' => options[:dynamic_fields_id],
        'dynamic-fields-add-template' => CGI.escapeHTML(new_template).html_safe,
        'dynamic-fields-remove-template' => remove_template
      }) +
      collection_output +
      @template.content_tag(:script, nil, data: {
        'dynamic-fields-end' => options[:dynamic_fields_id]
      })
    end

    def dynamic_fields_add_link(association, label, options = {})
      @template.link_to(label, '#', {data: {'dynamic-fields-add' => dynamic_fields_id(association)}}.deep_merge(options))
    end

    def dynamic_fields_remove_link(label, options = {})
      data_options = {data: {'dynamic-fields-remove' => @options[:dynamic_fields_id]}}
      data_options[:data]['dynamic-fields-remove-id'] = @object.id if @object.try(:persisted?)

      @template.link_to(label, '#', data_options.deep_merge(options))
    end

    def fields_for_nested_model_with_dynamic_fields(name, object, fields_options, block)
      dynamic_item_begin_mark = fields_options.has_key?(:dynamic_fields_id) ?
        @template.content_tag(:script, nil, data: {
          'dynamic-fields-item-begin' => fields_options[:dynamic_fields_id]
        }) : ''

        dynamic_item_begin_mark +
        fields_for_nested_model_without_dynamic_fields(name, object, fields_options, block)
    end

    private

    def dynamic_fields_id(association)
      "#{self.object_id}-#{association}"
    end

  end
end
