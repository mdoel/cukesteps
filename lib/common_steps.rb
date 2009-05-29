Then /^I debug$/ do
  debugger
end

Then /^save_and_open_page$/ do
  save_and_open_page
end

Then /^I wait for ([0-9]+) seconds$/ do |delay|
  sleep delay.to_i
end

# Steps that are generally useful and help encourage use of semantic
# IDs and Class Names in your markup.  In the steps below, a match following
# "the" will verify the presences of an element with a given ID while a match following
# "a" or "an" will verify the presence an element of a given class.
Then /^I should see a (\S+) in the (\S+)$/ do |element, containing_element|
  response.should have_tag("##{containing_element} .#{element}")
end

Then /^I should see the (\S+) in the (\S+)$/ do |element, containing_element|
  response.should have_tag("##{containing_element} ##{element}")
end

Then /^I should see (\d+) (\S+) in the (\S+)$/ do |count, element, containing_element|
  response.should have_tag("##{containing_element} .#{element.singularize}",:count => count.to_i)
end

Then /^I should see (\d+) to (\d+) (\S+) in the (\S+)$/ do |min, max, element, containing_element|
  response.should have_tag("##{containing_element} .#{element.singularize}",min.to_i..max.to_i)
end

Then /^the (\S+) in the (\S+) should contain (a|an|the) (\S+)$/ do |middle_element, outer_element, a, inner_element|
  response.should have_tag("##{outer_element} .#{middle_element} .#{inner_element}")
end

Then /^I should see the (\S+)$/ do |element_id|
  response.should have_tag("##{element_id}")
end

Then /^I should see (a|an) (\S+)$/ do |a, element_class|
  response.should have_tag(".#{element_class}")
end

Then /^(\d+) (\S+) should exist$/ do |count, element_class|
  klass = element_class.singularize.capitalize.constantize
  klass.count.should eql(count.to_i)
end

Given /^the following resorts$/ do |table|
  table.hashes.each do |params_hash|
   hash = params_hash.dup
   attributes = handle_association_params(hash) 
   hash.each { |k,v| attributes[k.gsub(' ','').underscore.to_sym] = v }
   create_resort(attributes)
  end
end


Given /^the following (\S+) exist$/ do |model_class_name,table|
  @created_objects ||= {}
  model_class_name = model_class_name.downcase.singularize
  table.hashes.each do |params_hash|
    hash = {}
    params_hash.each {|k,v| hash[k.downcase] = v}
    attributes = {}
    object_name = hash.delete(model_class_name)
    @created_objects[model_class_name] ||= {} if !object_name.nil?
    hash.each do |key,value|
      normalized_key = key.downcase.gsub(' ','_')
      if @created_objects[key].nil?
        attributes[normalized_key.to_sym] = value
      else
        attributes[normalized_key.to_sym] = @created_objects[key][value]
      end
    end
    new_object = create_model(model_class_name,attributes)
    @created_objects[model_class_name][object_name] = new_object if !object_name.nil?
  end
end

module CukeAssociationHelpers
  def cuke_association_builders(associations = [])
  end

  def handle_association_params(hash)
    attributes = {}
    ["location", "brand"].each do |attribute|
      value = hash.delete(attribute)
      if !value.nil?
        if attribute == "location"
          location = create_location(:address => value)
          attributes[:location] = location
        else
          brand = Brand.find_by_name(value)
          attributes[:brand] = brand
        end
      end
    end
    attributes
  end


  def create_model(model_name, attributes={})  
    send("create_#{model_name.gsub(' ','_')}",attributes)  
  end
end
World(CukeAssociationHelpers)
