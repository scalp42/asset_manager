class AssetExport
  # To change this template use File | Settings | File Templates.
  attr_accessor :description, :name, :asset_type, :fields

   @@name
   @@description
   @@asset_type
   @@fields

  def initialize
    @@name = nil
    @@description = nil
    @@asset_type = nil
    @@fields = nil
  end
end