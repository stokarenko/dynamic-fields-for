module DynamicFieldsFor
  module SimpleFormHelper
    # Used "simple_form/action_view_extensions/builder.rb" as sample
    def simple_dynamic_fields_for(*args, &block)
      options = args.extract_options!
      options[:wrapper] = self.options[:wrapper] if options[:wrapper].nil?
      options[:defaults] ||= self.options[:defaults]
      options[:wrapper_mappings] ||= self.options[:wrapper_mappings]

      if self.class < ActionView::Helpers::FormBuilder
        options[:builder] ||= self.class
      else
        options[:builder] ||= SimpleForm::FormBuilder
      end
      dynamic_fields_for(*args, options, &block)
    end
  end
end
