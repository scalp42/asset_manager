class AssetsController < ApplicationController

  def index
    @assets = Asset.all

  end

  def create
    @asset_type = AssetType.find(BSON::ObjectId.from_string(params[:id]))
  end

  def save
    asset = Asset.new(:name => params[:name][:name],:description => params[:description][:description])

    asset_type = AssetType.find(BSON::ObjectId.from_string(params[:asset_type][:asset_type_id]))

    asset.asset_type_id = asset_type.id
    asset.asset_type_name = asset_type.name

    asset_type.asset_screen.each do |field|
      fieldObj = Field.find(field.field_id)
      if params[fieldObj.name][fieldObj.name] != nil
        case params[fieldObj.name][fieldObj.name+'_type']
          when 'option'
            asset.field_value.build(:id => fieldObj.id,
                                    :asset_id => asset.id ,
                                    :field_option_id => params[fieldObj.name][fieldObj.name],
                                    :field_id => fieldObj.id,
                                    :text_value => fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name]  )).option)
          when 'text'
            asset.field_value.build(:id => fieldObj.id,
                                    :asset_id => asset.id,
                                    :text_value => params[fieldObj.name][fieldObj.name],
                                    :field_id => fieldObj.id)
          when 'date'
            asset.field_value.build(:id => fieldObj.id,
                                    :asset_id => asset.id,
                                    :date => params[fieldObj.name][fieldObj.name],
                                    :field_id => fieldObj.id)
          else
            puts "field not found"
        end
      end
    end

    asset.save

    redirect_to :action => 'index'
  end

  def delete
    Asset.destroy(params[:asset_id])

    redirect_to :back
  end

  def edit
    @asset = Asset.find(params[:id])

  end

  def update

    asset = Asset.find(params[:asset][:asset_id])

    if(params[:name][:name] != nil)
      asset.name = params[:name][:name]
    else
      asset.name = nil
    end

    if(params[:description][:description] != nil)
      asset.description = params[:description][:description]
    else
      asset.description = nil
    end

    AssetType.find(asset.asset_type_id).asset_screen.each do |field|
      fieldObj = Field.find(field.field_id)
      if params[fieldObj.name][fieldObj.name] != nil
        asset.field_value.each do |fieldValue|
          if(fieldObj.id == fieldValue.field_id)
            case params[fieldObj.name][fieldObj.name+'_type']
              when 'option'
                if fieldValue != nil
                  asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_option_id = params[fieldObj.name][fieldObj.name] }
                else
                  asset.field_value.build(:asset_id => asset.id ,
                                          :field_option_id => params[fieldObj.name][fieldObj.name],
                                          :field_id => fieldObj.id)
                end
              when 'text'
                if fieldValue == nil
                  asset.field_value.build(:asset_id => asset.id,
                                          :text_value => params[fieldObj.name][fieldObj.name],
                                          :field_id => fieldObj.id)
                elsif params[fieldObj.name][fieldObj.name] != ''
                  asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.text_value = params[fieldObj.name][fieldObj.name] }
                elsif fieldValue != nil
                  fieldValue.destroy
                end
              when 'date'
                if fieldValue != nil
                  asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.date = params[fieldObj.name][fieldObj.name] }
                else
                  asset.field_value.build(:asset_id => asset.id,
                                          :date => params[fieldObj.name][fieldObj.name],
                                          :field_id => fieldObj.id)

                end
              else
                puts "field not found"
            end
          end
        end
      elsif params[fieldObj.name][fieldObj.name] == nil and  FieldValue.first(:conditions => ['asset_id=?  and field_id=?',asset.id,fieldObj.id]) != nil
        FieldValue.destroy(FieldValue.first(:conditions => ['asset_id=?  and field_id=?',asset.id,fieldObj.id]).id)
      end
    end

    asset.save
    redirect_to :action => 'index'
  end

  def view
    @asset = Asset.find(params[:id])
  end
end
