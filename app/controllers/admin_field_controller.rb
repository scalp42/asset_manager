class AdminFieldController < ApplicationController
  layout 'admin'

  def list_fields
    @fields = Field.all
    render :template => 'admin_field/list_fields'
  end

  def list_asset_types
    @asset_types = AssetType.all
    puts "JKSDJFKLSDJLKF"+@asset_types.inspect
    render :template => 'admin_field/list_asset_types'
  end

  def create
    newField = Field.new(:field_type_id => params[:field_type][:field_type_id] ,:description => params[:description][:field_type_description],:name => params[:name][:field_type_name])

    if newField.save
      redirect_to :back
    end

  end

  def create_asset_type
    newAssetType = AssetType.new(:description => params[:description][:asset_type_description],:name => params[:name][:asset_type_name])

    if newAssetType.save
      redirect_to :back
    end
  end

  def delete
    if Field.delete(params['field_id'])
         redirect_to :back
       end
  end

  def delete_asset_type
    if AssetType.delete(params['asset_type_id'])
        redirect_to :back
    end
  end
end
