describe '#dynamic_fields_for' do
  def expect_result(user)
    expect(page).to have_button('Update User')
    expect(user.roles.map(&:role_name)).to match_array(['role 0', 'role 1', 'role 2', 'new role 0', 'new role 1', 'new role 2'])
  end

  def role_inputs
    all('[name$="[role_name]"]')
  end

  def deal_with_dynamic_roles
    3.times{ click_link 'Add role' }

    role_inputs.last(3).each_with_index do |element, index|
      element.set("new role #{index}")
    end
  end

  let(:user){User.first}

  it 'should pass for new object' do
    visit "/users/new"

    deal_with_dynamic_roles

    fill_in 'user[user_name]', with: 'New user'
    role_inputs.first(3).each_with_index do |element, index|
      element.set("role #{index}")
    end

    click_button 'Create User'

    expect_result(User.find(URI.parse(current_url).path.match(/users\/(\d+)\/edit/)[1]))
  end

  it 'should pass for existing object' do
    visit "/users/#{user.id}/edit"

    deal_with_dynamic_roles

    click_button 'Update User'

    expect_result(user)
  end
end
