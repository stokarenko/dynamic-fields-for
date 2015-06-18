DynamicFieldsFor
================
[![Version](https://badge.fury.io/rb/dynamic-fields-for.svg)](http://badge.fury.io/rb/dynamic-fields-for)
[![Build](https://travis-ci.org/stokarenko/dynamic-fields-for.svg?branch=master)](https://travis-ci.org/stokarenko/dynamic-fields-for)
[![Climate](https://codeclimate.com/github/stokarenko/dynamic-fields-for/badges/gpa.svg)](https://codeclimate.com/github/stokarenko/dynamic-fields-for)
[![Coverage](https://codeclimate.com/github/stokarenko/dynamic-fields-for/badges/coverage.svg)](https://codeclimate.com/github/stokarenko/dynamic-fields-for/coverage)

DynamicFieldsFor is a Rails plugin which provides the dynamic association fieldsets to your forms without a pain. And it does nothing more.

The main features are:
* Not breaks the HTML layout - no any wrappers, additional divs etc;
* Works with fields block, i.e. not requires the separated partial for them;
* Not provides new form helpers, but extend the existing one;
* Simple and predictable interface and behavior;
* Not requires any special HTML entities inside templates;
* Supports [Simple Form](https://github.com/plataformatec/simple_form).
* Supports not ActiveRecord models

## Alternatives
* [coccon](https://github.com/nathanvda/cocoon)
* [Nested Form](https://github.com/ryanb/nested_form)

## Dependencies
* Ruby >= 1.9.3
* [rails](https://github.com/rails/rails) >= 3.2.13
* [jquery-rails](https://github.com/rails/jquery-rails)
* [activerecord-devkit](https://github.com/stokarenko/activerecord-devkit), `association_soft_build` feature

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

Skip `allow_destroy` definition if you don't need to use `remove_fields_link` helper).

Take care about strong parameters in controller like that:
```ruby
params.require(:user).permit(roles_attributes: [:id, :_destroy])
```

It is important to permit `id` role's parameter, don't miss it. As for `_destroy`,
skip it if you don't need to use `remove_fields_link` helper.

Then, in view:
```haml
= form_for resource do |f|
  = f.text_field :user_name

  = f.fields_for :roles, dynamic: true do |rf|
    = rf.text_field :role_name
    = rf.remove_fields_link 'Remove role'

  = f.add_fields_link :roles, 'Add role'

  = f.submit
```

DynamicFieldsFor supports SimpleForm:
```haml
= simple_form_for resource do |f|
  = f.input :user_name

  = f.simple_fields_for :roles, dynamic: true do |rf|
    = rf.input :role_name
    = rf.remove_fields_link 'Remove role'

  = f.add_fields_link :roles, 'Add role'

  = f.submit
```

## Not ActiveRecord models
To use DynamicFieldsFor with not ActiveRecord, need to define two methods in your model, `{association}_soft_build` and `{association}_attributes=`:

```ruby
class EmailForm
  include ActiveAttr::Model

  attribute :recipients, type: Object, default: []

  def recipients_attributes=(attributes)
    self.recipients = attributes.values.map{ |attrs| recipients_soft_build(attrs) }
  end

  def recipients_soft_build(attrs = {})
    Recipient.new(attrs)
  end

end

class Recipient
  include ActiveAttr::Model

  attribute :email

  validates :email,  presence: true
end
```

Template will stay to be as usual:
```haml
= form_for resource do |f|
  = f.fields_for :recipients, dynamic: true do |rf|
    = rf.text_field :email
    = rf.remove_fields_link 'Remove recipient'

  = f.add_fields_link :recipients, 'Add recipient'

  = f.submit
```

## JavaScript events
There are the events which will be triggered on `add_fields_link` click, in actual order:
* `dynamic-fields:before-add-into` touched to dynamic fields parent node;
* `dynamic-fields:after-add` touched to each first-level elements which was inserted;
* `dynamic-fields:after-add-into` touched to dynamic fields parent node;

Like that, these events will be triggered on `add_fields_link` click, in actual order:
* `dynamic-fields:before-remove-from` touched to dynamic fields parent node;
* `dynamic-fields:before-remove` touched to each first-level elements which going to be removed;
* `dynamic-fields:after-remove-from` touched to dynamic fields parent node;

Typical callback for dynamic fields parent node looks like:
```js
$(document).on('dynamic-fields:after-add-into', function(event){
  $(event.target).find('li').order();
})
```

As for first-level elements, need to remember that compatible callbacks
will be triggered to each of them. To deal with this,
use `$.find2` javascript helper, which provided by DynamicFieldsFor:
```js
$('#some_id').find2('.some_class');
// doing the same as...
$('#some_id').find('.some_class').add($('#some_id').filter('.some_class'));
```

Typical event callback first-level elements should looks like:
```js
$(document).on('dynamic-fields:after-add', function(event){
  $(event.target).find2('.datepicker').datetimepicker();
})
```

## License
MIT License. Copyright (c) 2015 Sergey Tokarenko
