defmodule CheckboxTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  use Retry
  hound_session()

  @checkbox_url "https://the-internet.herokuapp.com/checkboxes"
  @checkbox_1_path "input:nth-child(1)"
  @checkbox_3_path "input:nth-child(3)"


  def page_setup_and_verify do
    # These are the conditions I expect to be present on each new page load, so putting them in a function I can call to not repeat myself.
    navigate_to(@checkbox_url, 1)
    assert current_url() == @checkbox_url

    #Confirming checkboxes are present
    checkbox_1 = find_element(:css, @checkbox_1_path)
    assert element_displayed?(checkbox_1)

    checkbox_3 = find_element(:css, @checkbox_3_path)
    assert element_displayed?(checkbox_3)


    #Other specific checks we would want to have done for each test could be continued here
  end

  test "default checkbox state" do
    # Confirming that checkbox 3 is checked, while checkbox one is not checked. (default state correct)

    page_setup_and_verify()

    checkbox_1 = find_element :css, @checkbox_1_path
    assert selected?(checkbox_1) == false

    checkbox_3 = find_element :css, @checkbox_3_path
    assert selected?(checkbox_3)

  end

  test "test checkboxes are clickable" do
    # Confirming that checkboxes are able to be clicked and selected.

    page_setup_and_verify()

    # Just as a proof of concept, i'll implement some retry logic here as well.
    checkbox_1 = find_element :css, @checkbox_1_path
    assert selected?(checkbox_1) == false
    click checkbox_1
    assert selected?(checkbox_1)
    click checkbox_1

    # Retrying assert 3 times with 1 second intervals.
    assertion_result = retry with: constant_backoff(1000) |> Stream.take(3) do
      assert selected?(checkbox_1) == false
    after
      assertion_result -> assertion_result
    else
      error -> error
    end


    checkbox_3 = find_element :css, @checkbox_3_path
    assert selected?(checkbox_3)
    click checkbox_3
    assert selected?(checkbox_3)  == false
    click checkbox_3
    
    # Retrying assert 3 times with 1 second intervals.
    assertion_result = retry with: constant_backoff(1000) |> Stream.take(3) do
      assert selected?(checkbox_3)
    after
      assertion_result -> assertion_result
    else
      error -> error
    end

  end

end
