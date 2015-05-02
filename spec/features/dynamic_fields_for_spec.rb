describe '#dynamic_fields_for' do
  let(:user){User.first}

  it 'should pass for new object' do
    visit "/users/new"
    fill_in 'user[user_name]', with: 'New user'
    fill_in 'user[roles_attributes][0][role_name]', with: 'Role 1'
    fill_in 'user[roles_attributes][1][role_name]', with: 'Role 2'
    fill_in 'user[roles_attributes][2][role_name]', with: 'Role 3'


    click_button 'Create User'

    expect(page).to have_button('Update User')
  end

  it 'should pass for existing object' do
    visit "/users/#{user.id}/edit"
    click_button 'Update User'

    expect(page).to have_button('Update User')
  end
end
