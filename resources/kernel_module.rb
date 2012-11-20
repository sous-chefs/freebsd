actions :enable, :disable

def initialize(*args)
  super
  @action = :enable
end

attribute :name, :kind_of => String, :name_attribute => true
