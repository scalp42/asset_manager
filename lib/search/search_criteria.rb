class SearchCriteria
  attr_accessor :description, :name, :asset_types, :fields

  @@name
  @@description
  @@asset_types
  @@fields

  def initialize
    @@name = nil
    @@description = nil
    @@asset_types = nil
    @@fields = nil
  end

end