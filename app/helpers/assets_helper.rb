module AssetsHelper

  def setFieldValue(params,fieldObj,asset)
    case params[fieldObj.name][fieldObj.name+'_type']
      when 'single_option'
        asset.field_value.build(:id => fieldObj.id,
                                :asset_id => asset.id ,
                                :field_option_id => params[fieldObj.name][fieldObj.name],
                                :field_id => fieldObj.id,
                                :text_value => fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name])).option)
      when 'multi_option'
        options = Array.new
        options.push(params[fieldObj.name][fieldObj.name])
        asset.field_value.build(:id => fieldObj.id,
                                :asset_id => asset.id ,
                                :field_option_id => options,
                                :field_id => fieldObj.id,
                                :text_value => fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name])).option)
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

  def updateFieldValue(params,fieldObj,fieldValue,asset)
    case params[fieldObj.name][fieldObj.name+'_type']
      when 'single_option'
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_option_id = fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name]  )).id.to_s, b.text_value = fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name]  )).option}
      when 'multi_option'
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_option_id = fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name]  )).id.to_s, b.text_value = fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name]  )).option}
      when 'text'
        if params[fieldObj.name][fieldObj.name] != ''
          asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.text_value = params[fieldObj.name][fieldObj.name] }
        elsif fieldValue != nil
          Asset.pull(asset.id, {:field_option => {:_id => fieldObj.id}})
        end
      when 'date'
          asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.date = params[fieldObj.name][fieldObj.name] }
      else
        puts "field not found"
    end
  end

end
