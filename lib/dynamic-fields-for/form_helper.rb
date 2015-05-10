module DynamicFieldsFor
  module FormHelper
    extend ActiveSupport::Concern

    included do
      alias_method_chain :fields_for, :dynamic_fields
      alias_method_chain :fields_for_nested_model, :dynamic_fields
    end

    def fields_for_with_dynamic_fields(association, record_object = nil, options = {}, &block)
      #Inherit the native parameters adjustment
      options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?

      return fields_for_without_dynamic_fields(association, record_object, options, &block) unless options.delete(:dynamic)

      new_object = @object.send(association).soft_build

      options[:child_index] = 'dynamic_fields_index'
      remove_template = fields_for_without_dynamic_fields(association, new_object, options) do |f|
        f.hidden_field(:id, value: 'dynamic_fields_object_id') +
        f.hidden_field(:_destroy, value: true)
      end

      options[:dynamic_fields_id] = dynamic_fields_id(association)
      add_template = fields_for_without_dynamic_fields(association, new_object, options, &block)

      options.delete(:child_index)
      collection_output = fields_for_without_dynamic_fields(association, record_object, options, &block)

      cover_by_anchors(
        {
          begin: options[:dynamic_fields_id],
          'add-template' => CGI.escapeHTML(add_template),
          'remove-template' => CGI.escapeHTML(remove_template)
        },
        collection_output,
        {end: options[:dynamic_fields_id]}
      )
    end

    def add_fields_link(association, label, options = {})
      @template.link_to(label, '#', dynamic_fields_data_options(add: dynamic_fields_id(association)).deep_merge(options))
    end

    def remove_fields_link(label, options = {})
      anchor_options = {}.tap do |mem|
        if @options.has_key?(:dynamic_fields_id)
          mem[:remove] = @options[:dynamic_fields_id]
          mem['remove-id'] = @object.id if @object.try(:persisted?)
        end
      end

      @template.link_to(label, '#', dynamic_fields_data_options(anchor_options).deep_merge(options))
    end

    def fields_for_nested_model_with_dynamic_fields(name, object, fields_options, block)
      cover_by_anchors_if(
        fields_options.has_key?(:dynamic_fields_id),
        {'item-begin' => fields_options[:dynamic_fields_id]},
        fields_for_nested_model_without_dynamic_fields(name, object, fields_options, block)
      )
    end

    private

    def dynamic_fields_id(association)
      "#{self.object_id}-#{association}"
    end

    def dynamic_fields_data_options(anchor_options)
      return nil if anchor_options.nil?

      anchor_options.inject({data: {}}) do |mem, (key, value)|
        mem[:data][:"dynamic-fields-#{key}"] = value.html_safe? ? value : value.html_safe
        mem
      end
    end

    def cover_by_anchors(begin_anchor_options, content, end_anchor_options = nil)
      anchor(begin_anchor_options) + content + anchor(end_anchor_options)
    end

    def cover_by_anchors_if(condition, begin_anchor_options, content, end_anchor_options = nil)
      condition ?
        cover_by_anchors(begin_anchor_options, content, end_anchor_options) :
        content
    end

    def anchor(anchor_options)
      return ''.html_safe if anchor_options.nil?

      @template.content_tag(:script, nil, dynamic_fields_data_options(anchor_options))
    end

  end
end
