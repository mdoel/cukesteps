module CukeAssociationBuilder
  module ClassMethods
    def cuke_association_builds_via_name
    end
  end
  def self.included(other)
    puts "#{other} is included"
    other.extend ClassMethods
  end
end

