module SearchHelper

  def createFilter(params,fields)

    if params[:filter_value] != nil
      filter = Filter.new(:available => true,:name => params[:filter_value])
      filter.save

      if params[:asset_type][:asset_type_id] != nil and params[:asset_type][:asset_type_id].count > 1
        params[:asset_type][:asset_type_id].each do |asset_type|
          if asset_type != ''
            filterDetails = FilterDetails.new(:asset_type_id => asset_type,:filter_id=> filter.id )
            filterDetails.save
          end
        end
      end

      if params[:name][:name] != ''
        filterDetails = FilterDetails.new(:name => params[:name][:name],:filter_id=> filter.id )
        filterDetails.save
      end

      if params[:description][:description] != ''
        filterDetails = FilterDetails.new(:description => params[:description][:description],:filter_id=> filter.id )
        filterDetails.save
      end

      fields.each do |key, value|
        field = Field.find(key)
        if(FieldType.find(field.field_type_id)).use_option?
          value.each do |option|
            if option != ''
              filterDetails = FilterDetails.new(:field_option_id => option,:field_id => key,:filter_id=> filter.id )
              filterDetails.save
            end
          end
        elsif (FieldType.find(field.field_type_id)).use_date?
          filterDetails = FilterDetails.new(:date_search => value,:field_id => key,:filter_id=> filter.id )
          filterDetails.save
        elsif (FieldType.find(field.field_type_id)).use_text?
          filterDetails = FilterDetails.new(:text_search => value,:field_id => key,:filter_id=> filter.id )
          filterDetails.save
        end
      end
    end
  end
end
