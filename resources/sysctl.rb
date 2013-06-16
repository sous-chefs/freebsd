actions :set

def initialize(*args)
  super
  @action = :set
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :value, :required => true
