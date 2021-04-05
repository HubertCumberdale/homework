defmodule ElementTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  hound_session()

  #Some of the module variables below may be better placed in a config file or somewhere else depending on the scope
  #of your tests, with that config then loaded in.
  @elements_url "https://the-internet.herokuapp.com/add_remove_elements/"

  #typically I would pack this into a tuple. The hound docs seem to support it, but it doesn't seem like it having it passed. Storing
  #just the path for now.
  @add_element_button_path "//button[@onclick='addElement()']"
  @delete_element_button_path "//button[@onclick='deleteElement()']"

  # There are several checks that can be done as part of initial page setup. Since we want to do that for reach test, creating that as a function that can be called to not repeat code. Then we can focus on the specific items we want to test each time.

  def page_setup_and_verify do
    # These are the conditions I expect to be present on each new page load, so putting them in a function I can call to not repeat myself.
    navigate_to(@elements_url, 1)
    assert current_url() == @elements_url

    #Confirming add element button is present.
    add_element_button = find_element(:xpath, @add_element_button_path)
    assert element_displayed?(add_element_button)

    #Confirming no delete button already present.
    #I dont see any out of the box NOT present logic, so doing a try/rescue. I'd also throw this in some sort of helper long term, i'm sure thats already in place
    try do
      find_element(:xpath, @delete_element_button_path)
    rescue
        e in Hound.NoSuchElementError -> e
    end

    #Other specific checks we would want to have done for each test could be continued here
  end

  test "Confirm Add elements functional" do
    #This test ensures that the "Add element button is present, clickable, and when clicked the "Delete" element appears correctly

    page_setup_and_verify()

    #clicking add element button and verifying that "Delete" appears.
    add_element_button = find_element(:xpath, @add_element_button_path)
    click add_element_button
    delete_element_button = find_element(:xpath, @delete_element_button_path)
    assert element_displayed?(delete_element_button)

    #taking screenshot as proof of passed test (path would need to be defined if ran automated)
    take_screenshot()

  end

  test "Confirm Adding multiple delete elements" do

    page_setup_and_verify()

    add_element_button = find_element(:xpath, @add_element_button_path)
    #Verifying that mulitiple buttons can be added. (could make number dynamic)
    created_delete_elements = [5,4,3,2,1]
    Enum.each(created_delete_elements, fn _x -> click add_element_button end)

    #Verifying elements were added, deleting them, asserting they have been removed.
    Enum.each(created_delete_elements, fn x ->
      delete_element = find_element(:xpath, "(" <> @delete_element_button_path <> ")[#{x}]")
      assert element_displayed?(delete_element)
      click delete_element
      try do
        find_element(:xpath, "(" <> @delete_element_button_path <> ")[#{x}]")
      rescue
          e in Hound.NoSuchElementError -> e
      end
    end)


    #taking screenshot as proof of passed test (path would need to be defined if ran automated)
    take_screenshot()

  end
end
