class AssetsController < ApplicationController

  def index
    @assets = Asset.all
  end

  def create
    @asset_type = AssetType.find(params[:id])
  end

  def save
    asset = Asset.new(:name =>params[:name][:name],:description => params[:description][:description],:asset_type_id => params[:asset_type][:asset_type_id])
    asset.save

    AssetScreen.find_all_by_asset_id(params[:asset_type][:asset_type_id]).each do |field|
      fieldObj = Field.find(field)
      if params[fieldObj.name][fieldObj.name] != nil
        case params[fieldObj.name][fieldObj.name+'_type']
          when 'option'
            fieldValue = FieldValue.new(:asset_id => asset.id ,
                                        :field_option_id => params[fieldObj.name][fieldObj.name],
                                        :field_id => fieldObj.id)
            fieldValue.save
          when 'text'
            fieldValue = FieldValue.new(:asset_id => asset.id,
                                        :text_value => params[fieldObj.name][fieldObj.name],
                                        :field_id => fieldObj.id)
            fieldValue.save
          when 'date'
            fieldValue = FieldValue.new(:asset_id => asset.id,
                                        :date => params[fieldObj.name][fieldObj.name],
                                        :field_id => fieldObj.id)
            fieldValue.save
          else
            puts "field not found"
        end
      end
    end

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

    puts params.inspect
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

    asset.save

    AssetScreen.find_all_by_asset_id(asset.asset_type_id).each do |field|
      fieldObj = Field.find(field.field_id)
      if params[fieldObj.name][fieldObj.name] != nil
        case params[fieldObj.name][fieldObj.name+'_type']
          when 'option'
            fieldValue = FieldValue.first(:conditions => ['asset_id=?  and field_id=?',asset.id,fieldObj.id])
            if fieldValue != nil
            fieldValue.field_option_id = params[fieldObj.name][fieldObj.name]
            else
              fieldValue = FieldValue.new(:asset_id => asset.id ,
                                          :field_option_id => params[fieldObj.name][fieldObj.name],
                                          :field_id => fieldObj.id)
            end
            fieldValue.save

          when 'text'
            fieldValue = FieldValue.first(:conditions => ['asset_id=?  and field_id=?',asset.id,fieldObj.id])
            if fieldValue == nil
              fieldValue = FieldValue.new(:asset_id => asset.id,
                                          :text_value => params[fieldObj.name][fieldObj.name],
                                          :field_id => fieldObj.id)
              fieldValue.save
            elsif params[fieldObj.name][fieldObj.name] != ''
              fieldValue.text_value = params[fieldObj.name][fieldObj.name]
              fieldValue.save
            elsif fieldValue != nil
              fieldValue.destroy
            end
          when 'date'
            fieldValue = FieldValue.first(:conditions => ['asset_id=?  and field_id=?',asset.id,fieldObj.id])
            if fieldValue != nil
              fieldValue.date = params[fieldObj.name][fieldObj.name]
              fieldValue.save
            else
              fieldValue = FieldValue.new(:asset_id => asset.id,
                                          :date => params[fieldObj.name][fieldObj.name],
                                          :field_id => fieldObj.id)
              fieldValue.save
            end

          else
            puts "field not found"
        end
      elsif params[fieldObj.name][fieldObj.name] == nil and  FieldValue.first(:conditions => ['asset_id=?  and field_id=?',asset.id,fieldObj.id]) != nil
        FieldValue.destroy(FieldValue.first(:conditions => ['asset_id=?  and field_id=?',asset.id,fieldObj.id]).id)
      end
    end

    redirect_to :action => 'index'
  end

  def view
    @asset = Asset.find(params[:id])
  end
end
