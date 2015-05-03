DynamicFieldsFor
================

DynamicFieldsFor is a Rails plugin which provides the dynamic association fieldsets to your form without pain.

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

Skip `allow_destroy` definition if you don't need to use `remove_fields` helper).

Take care about strong parameters in controller like that:
```ruby
params.require(:user).permit(roles_attributes: [:id, :_destroy])
```

It is important to allow `id` role's parameter, don't miss it. As for `_destroy`,
skip it if you don't need to use `remove_fields` helper.

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

DynamicFieldsFor supports SimpleForm, use it like:
```haml
= simple_form_for resource do |f|
  = f.input :user_name

  = f.simple_dynamic_fields_for :roles do |rf|
    = rf.input :role_name
    = rf.dynamic_fields_remove_link 'Remove role'

  = f.dynamic_fields_add_link :roles, 'Add role'

  = f.submit
```

## TODO
* Try use HTML comments instead script tags.
