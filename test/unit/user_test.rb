require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Admin user should be valid" do
    admin = Factory(:admin)
    assert admin.valid?
  end
  
  test "Admin should be admin" do
    admin = Factory(:admin)
    assert admin.admin?
  end
  
  test "User should be valid" do
    user = Factory(:user)
    assert user.valid?
  end
  
  test "User should not be admin" do
    user = Factory(:user)
    assert !user.admin?
  end
  
  test "User should be from csindi.com" do
    user = Factory(:user)
    user.email = "intruder@somewhere.com"
    assert user.invalid?
  end
  
  test "User returns user name" do
    user = Factory(:user, :email => "john.doe@csindi.com")
    assert_respond_to user, :full_name, "should respond to full_name method"
    assert_equal "John Doe", user.full_name
    
    user = Factory(:user, :email => "admin@csindi.com")
    assert_equal "Admin", user.full_name
  end
  
  test "User has his name set during creation" do
    user = Factory(:user, email: "jane.doe@csindi.com")
    assert_equal 'Jane', user.first_name, "Should set first name"
    assert_equal 'Doe', user.last_name, "Should set last name" 
  end
  
  test "User can be promoted to admin" do
    user = Factory(:user)
    user.promote
    assert user.reload.admin?, "Should become admin"
  end
  
end
