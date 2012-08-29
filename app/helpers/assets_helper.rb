module AssetsHelper

  def setCascadeValue(params,fieldObj,asset)
    if params[fieldObj.name.gsub(" ","_")+"_child"][fieldObj.name.gsub(" ","_")+"_child"] != "null"
      asset.field_value.build(:id => fieldObj.id,
                              :asset_id => asset.id ,
                              :parent_field_option_id => params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"],
                              fieldObj.name.downcase.gsub(" ","_")+"_parent" => params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"],
                              fieldObj.name.downcase.gsub(" ","_")+"_child" => params[fieldObj.name.gsub(" ","_")+"_child"][fieldObj.name.gsub(" ","_")+"_child"],
                              :fieldNameValue => {"name" => fieldObj.name.downcase.gsub(" ","_"),"parent_value" =>params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"],"child_value" => params[fieldObj.name.gsub(" ","_")+"_child"][fieldObj.name.gsub(" ","_")+"_child"] } ,
                              :child_field_option_id => params[fieldObj.name.gsub(" ","_")+"_child"][fieldObj.name.gsub(" ","_")+"_child"],
                              :field_id => fieldObj.id)
    else
      asset.field_value.build(:id => fieldObj.id,
                              :asset_id => asset.id ,
                              :parent_field_option_id => params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"],
                              fieldObj.name.downcase.gsub(" ","_")+"_parent" => params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"],
                              :fieldNameValue => {"name" => fieldObj.name.downcase.gsub(" ","_"),"parent_value" =>params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"]},
                              :child_field_option_id => 'empty',
                              :field_id => fieldObj.id)
    end
  end

  def updateCascadeValue(params,fieldObj,asset)
    asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.parent_field_option_id = params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"] }
    if params[fieldObj.name.gsub(" ","_")+"_child"][fieldObj.name.gsub(" ","_")+"_child"] != "null"
      asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.child_field_option_id = params[fieldObj.name.gsub(" ","_")+"_child"][fieldObj.name.gsub(" ","_")+"_child"] }
      asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_name_value = {fieldObj.name.downcase.gsub(" ","_")+"_parent_value" =>params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"],fieldObj.name.downcase.gsub(" ","_")+"_child_value" => params[fieldObj.name.gsub(" ","_")+"_child"][fieldObj.name.gsub(" ","_")+"_child"] } }
    else
      asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_name_value = { fieldObj.name.downcase.gsub(" ","_")+"_parent_value" =>params[fieldObj.name.gsub(" ","_")+"_parent"][fieldObj.name.gsub(" ","_")+"_parent"] } }
    end

  end

  def setFieldValue(params,fieldObj,asset)
    case params[fieldObj.name][fieldObj.name+'_type']
      when 'single_option'
        asset.field_value.build(:id => fieldObj.id,
                                :asset_id => asset.id ,
                                :field_option_id => params[fieldObj.name][fieldObj.name],
                                :field_id => fieldObj.id,
                                :field_name_value => {fieldObj.name.downcase.gsub(" ","_") =>params[fieldObj.name][fieldObj.name] } ,
                                :text_value => fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name])).option)
      when 'multi_option'
        options = Array.new
        options.push(params[fieldObj.name][fieldObj.name])
        asset.field_value.build(:id => fieldObj.id,
                                :asset_id => asset.id ,
                                :field_option_id => options,
                                :field_name_value => {fieldObj.name.downcase.gsub(" ","_") =>options } ,
                                :field_id => fieldObj.id)
      # :text_value => fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name])).option)
      when 'text'
        asset.field_value.build(:id => fieldObj.id,
                                :asset_id => asset.id,
                                :text_value => params[fieldObj.name][fieldObj.name],
                                :field_name_value => {fieldObj.name.downcase.gsub(" ","_") =>params[fieldObj.name][fieldObj.name] } ,
                                :field_id => fieldObj.id)
      when 'date'
        asset.field_value.build(:id => fieldObj.id,
                                :asset_id => asset.id,
                                :date => params[fieldObj.name][fieldObj.name],
                                :field_name_value => {fieldObj.name.downcase.gsub(" ","_") =>params[fieldObj.name][fieldObj.name] } ,
                                :field_id => fieldObj.id)
      when 'file_upload'
        asset.field_value.build(:id => fieldObj.id,
                                :asset_id => asset.id,
                                :attachment => params[fieldObj.name][fieldObj.name],
                                :field_id => fieldObj.id)
      else
        puts "field not found"
    end
  end

  def updateFieldValue(params,fieldObj,fieldValue,asset)
    case params[fieldObj.name][fieldObj.name+'_type']
      when 'single_option'
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b|  b.field_option_id = fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name]  )).id}
        asset.field_value.select {|b| b.field_id == fieldObj.id}.each {|b| b.text_value = fieldObj.field_option.find(BSON::ObjectId.from_string(params[fieldObj.name][fieldObj.name]  )).option}
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_name_value = {fieldObj.name.downcase.gsub(" ","_") => params[fieldObj.name][fieldObj.name] } }
      when 'multi_option'
        options = Array.new
        options.push(params[fieldObj.name][fieldObj.name])
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_option_id = options}
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_name_value = {fieldObj.name.downcase.gsub(" ","_")=> options} }
      when 'text'
        if params[fieldObj.name][fieldObj.name] != ''
          asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.text_value = params[fieldObj.name][fieldObj.name] }
          asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_name_value = {fieldObj.name.downcase.gsub(" ","_") => params[fieldObj.name][fieldObj.name] } }
        elsif fieldValue != nil
          Asset.pull(asset.id, {:field_option => {:_id => fieldObj.id}})
        end
      when 'date'
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.date = params[fieldObj.name][fieldObj.name] }
        asset.field_value.select { |b| b.field_id == fieldObj.id }.each { |b| b.field_name_value = {fieldObj.name.downcase.gsub(" ","_")=> params[fieldObj.name][fieldObj.name] } }
      else
        puts "field not found"
    end
  end


  def deleteFields(fieldsToDelete,asset)
    fieldsToDelete.each do |field|
      Asset.pull(asset.id, {:field_value => {:_id => field}})
    end
  end

  def search()

  end
end
