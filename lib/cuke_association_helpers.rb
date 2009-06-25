module CukeAssociationHelpers
  
  def cuke_association_attributes(associations = {})
    @@associated_cuke_builders ||= {}
    associations.each { |k,v| @@associated_cuke_builders[k] = v }
  end

  def build_cuke_objects(model_class_name, table)
    @created_objects ||= {}
    @model_class_name = model_class_name.downcase.singularize
    build_cuke_objects_with_associations(table)
  end

  def build_cuke_objects_with_associations(table)
    table.hashes.each do |params_hash|
      build_one_cuke_object params_hash
    end
  end

  def build_one_cuke_object(params_hash)
    hash = duplicate_with_lc_keys(params_hash)
    object_name = hash.delete(@model_class_name)
    @created_objects[@model_class_name] ||= {} if !object_name.nil?
    attributes = assemble_attributes(hash,object_name)
    new_object = create_model(@model_class_name,attributes)
    @created_objects[@model_class_name][object_name] = new_object if !object_name.nil?
  end

  def duplicate_with_lc_keys(hash)
    normalized = {}
    hash.each {|k,v| normalized[k.downcase] = v}
    normalized
  end
  
  def assemble_attributes(hash,object_name)
    attributes = {}
    hash.each do |key,value|
      cached_key = key.singularize.downcase
      symbolized_key = key.downcase.gsub(' ','_').to_sym
      if @created_objects[cached_key].nil?
        attributes[symbolized_key] = build_value(symbolized_key,value)
      else
        attributes[symbolized_key] = @created_objects[cached_key][value]
      end
    end
    attributes
  end

  def build_value(key,value)
    if @@associated_cuke_builders[key].nil?
      value
    else
      build_value_from_association(key,value)
    end
  end

  def build_value_from_association(key,value)
    klass = class_from_symbol(key)
    builder_attribute = @@associated_cuke_builders[key]
    built_object = klass.send("find_by_#{builder_attribute}", value)
    if built_object.nil?
      built_object = create_model(key.to_s,{builder_attribute.to_sym => value})
    end
    built_object
  end

  def class_from_symbol(key)
    key.to_s.capitalize.constantize
  end

  def create_model(model_name, attributes={})  
    send("create_#{model_name.gsub(' ','_')}",attributes)  
  end
end
World(CukeAssociationHelpers)
