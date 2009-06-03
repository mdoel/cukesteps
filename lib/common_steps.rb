Then /^I debug$/ do
  debugger
end

Then /^save_and_open_page$/ do
  save_and_open_page
end

Then /^I wait for ([0-9]+) seconds$/ do |delay|
  sleep delay.to_i
end

Then /^(\d+) (\S+) should exist$/ do |count, element_class|
  klass = element_class.singularize.capitalize.constantize
  klass.count.should eql(count.to_i)
end

Then /^dump all (\S+) to standard output$/ do |klass|
  klass_name = klass.singularize.capitalize.constantize
  records = klass_name.send(:find, :all)
  records.each { |record| puts record.inspect }
end


# Steps that are generally useful and help encourage use of semantic
# IDs and Class Names in your markup.  In the steps below, a match following
# "the" will verify the presences of an element with a given ID while a match following
# "a" or "an" will verify the presence an element of a given class.
Then /^I should( not)? see the (\S+)$/ do |negation, element_id|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag("##{element_id}")
end

Then /^I should( not)? see an? (\S+)$/ do |negation, element_class|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag(".#{element_class}")
end

Then /^I should( not)? see an? (\S+) in the (\S+)$/ do |negation, element, containing_element|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag("##{containing_element} .#{element}")
end

Then /^I should( not)? see the (\S+) in the (\S+)$/ do |negation, element, containing_element|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag("##{containing_element} ##{element}")
end

Then /^I should( not)? see (\d+) (\S+) in the (\S+)$/ do |negation, count, element, containing_element|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag("##{containing_element} .#{element.singularize}",:count => count.to_i)
end

Then /^I should( not)? see (\d+) to (\d+) (\S+) in the (\S+)$/ do |negation, min, max, element, containing_element|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag("##{containing_element} .#{element.singularize}",min.to_i..max.to_i)
end

Then /^the (\S+) in the (\S+) should( not)? contain an? (\S+)$/ do |middle_element, outer_element, negation, inner_element|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag("##{outer_element} ##{middle_element} .#{inner_element}")
end

# Test for page title. E.g.:
# Then the page title should be "Login"
Then /^the page title should( not)? be "(.*)"$/ do |negation, expectation|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag('title', CGI::escapeHTML(expectation))
end

# Test for presence in page title. E.g.:
# Then the page title should contain "Login"
Then /^the page title should( not)? contain "(.*)"$/ do |negation, expectation|
  matcher = negation.blank? ? :should : :should_not
  response.send matcher, have_tag('title', /#{CGI::escapeHTML(expectation)}/)
end

# Test for presence in a particular flash. E.g.:
# Then flash should display "your update succeeded!" notice
Then /^flash should( not)? display "([^\"]*)" (\S+)$/ do |negation, message, message_type|
  matcher = negation.blank? ? :should : :should_not
  flash[message_type.to_sym].send(:eql?, message)
end

# Steps for creating objects that can be associated with other objects
Given /^the following (\S+) exist$/ do |model_class_name,table|
  build_cuke_objects model_class_name, table
end
