defmodule HoverTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  hound_session()


  @hover_url "https://the-internet.herokuapp.com/hovers"

  #typically I would pack this into a tuple. The hound docs seem to support it, but it doesn't seem like it having it passed. Storing
  #just the path for now.
  @h3_hovers_title "h3"
  @user_1_path ".figure:nth-child(3)"
  @user_2_path ".figure:nth-child(4)"
  @user_3_path ".figure:nth-child(5)"


  def page_setup_and_verify do
    # These are the conditions I expect to be present on each new page load, so putting them in a function I can call to not repeat myself.
    navigate_to(@hover_url, 1)
    assert current_url() == @hover_url

    #Confirming users are present.
    user_1 = find_element(:css, @user_1_path)
    assert element_displayed?(user_1)

    user_2 = find_element(:css, @user_2_path)
    assert element_displayed?(user_2)

    user_3 = find_element(:css, @user_3_path)
    assert element_displayed?(user_3)
    # Other specific checks we would want to have done for each test could be continued here
  end

  # Because I want to verify the same data for each user without making one large monolithic test, creating a function that can be reused for each user.
  def hover_display_hide_data(path, user_name) do
    h3_hovers_title = find_element(:css, @h3_hovers_title)
    user_icon = find_element(:css, path)
    view_profile_string = "View profile"

    # Verifying first that hover data is not already shown.
    assert (visible_text(user_icon) =~ user_name) == false
    assert (visible_text(user_icon) =~ view_profile_string) == false

    #hovering over user and verifying data displays.
    move_to(user_icon, 10, 10)
    assert (visible_text(user_icon) =~ user_name)
    assert (visible_text(user_icon) =~ view_profile_string)
    #taking screenshot here to document data is shown.
    take_screenshot()

    # Moving away from user and ensuring data is hidden.
    move_to(h3_hovers_title, 0, 0)

    assert (visible_text(user_icon) =~ user_name) == false
    assert (visible_text(user_icon) =~ view_profile_string) == false
  end

  test "user1 data displays and hides" do
    page_setup_and_verify()

    hover_display_hide_data(@user_1_path, "name: user1")
  end

  test "user2 data displays and hides" do
    page_setup_and_verify()

    hover_display_hide_data(@user_2_path, "name: user2")
  end

  test "user3 data displays and hides" do
    page_setup_and_verify()

    hover_display_hide_data(@user_3_path, "name: user3")
  end
end
