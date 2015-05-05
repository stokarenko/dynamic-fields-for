DynamicFieldsFor
================

DynamicFieldsFor is a Rails plugin which provides the dynamic association fieldsets to your forms without a pain. The main features are:
* Don't breakes the HTML layout - no any wrappers, additional divs etc;
* Works with fields block, i.e. not requires the separated partial for them;
* Not provides new form helpers, but extend the existing ones;
* Simple and predictable interface;
* Not requires any special HTML tags or layout inside templates;
* [Simple Form](https://github.com/plataformatec/simple_form) support.

## Alternatives
* [coccon](https://github.com/nathanvda/cocoon)
* [Nested Form](https://github.com/ryanb/nested_form)

## Getting started

Add to your Gemfile:

```ruby
  gem 'dynamic-fields-for'
```

Run the bundle command to install it.

Add to `app/assets/javascripts/application.js`:
```js
//= require dynamic-fields-for
```

## Usage
Lets say that we have the models:

```ruby
class User < ActiveRecord::Base
  has_many :roles
end

class Role < ActiveRecod::Base
  belongs_to :user

  validates :user, presence: true
end
```

First, apply `inverse_of` to User's `:roles` associations, otherwise no chance to pass
the validation of Role's user presence on user creation:
```ruby
class User < ActiveRecord::Base
  has_many :roles, inverse_of: :user
end
```

Add to User model:
```ruby
accepts_nested_attributes_for :roles, allow_destroy: true
```

Skip `allow_destroy` definition if you don't need to use `dynamic_fields_remove_link` helper).

Take care about strong parameters in controller like that:
```ruby
params.require(:user).permit(roles_attributes: [:id, :_destroy])
```

It is important to permit `id` role's parameter, don't miss it. As for `_destroy`,
skip it if you don't need to use `dynamic_fields_remove_link` helper.

Then, in view:
```haml
= form_for resource do |f|
  = f.text_field :user_name

  = f.dynamic_fields_for :roles do |rf|
    = rf.text_field :role_name
    = rf.dynamic_fields_remove_link 'Remove role'

  = f.dynamic_fields_add_link :roles, 'Add role'

  = f.submit
```

DynamicFieldsFor supports SimpleForm:
```haml
= simple_form_for resource do |f|
  = f.input :user_name

  = f.simple_dynamic_fields_for :roles do |rf|
    = rf.input :role_name
    = rf.dynamic_fields_remove_link 'Remove role'

  = f.dynamic_fields_add_link :roles, 'Add role'

  = f.submit
```

## JavaScript events
### Events triggered on inserted or removed elements
There are two events, `dynamic-fields:after-add` and `dynamic-fields:before-remove`,
which will be triggered by DynamicFieldsFor. They will be triggered to each
first-level element inserted by `dynamic_fields_add_link`, or removed by
`dynamic_fields_remove_link`, respectively. To deal with this,
use `$.find2` javascript helper, which provided by DynamicFieldsFor:

```js
$('#some_id').find2('.some_class');
// doing the same as...
$('#some_id').find('.some_class').add($('#some_id').filter('.some_class'));
```

Typical event callback should looks like:

```js
$(document).on('dynamic-fields:after-add', function(event){
  $(event.target).find2('.datepicker').datetimepicker();
})
```

## TODO
* Try use HTML comments instead script tags (?)
* Make coffeescript to be more readable.
