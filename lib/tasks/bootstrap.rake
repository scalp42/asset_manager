namespace :bootstrap do
      desc "Add Field Types"
      task :field_type => :environment do
        FieldType.create(:type_name => 'Single Line Text Field',:use_text => true,:is_searchable => true)
        FieldType.create(:type_name => 'Multi Line Text Field', :use_text => true,:is_searchable => true)
        FieldType.create(:type_name => 'Select Field',:use_option => true,:is_searchable => true)
        FieldType.create(:type_name => 'Multi Select Field',:use_option => true,:is_searchable => true)
        FieldType.create(:type_name => 'Cascading Select Field',:use_casecade_option => true,:is_searchable => true)
        FieldType.create(:type_name => 'Date Field',:use_date => true,:is_searchable => true)
        FieldType.create(:type_name => 'Radio Field',:use_radio_option => true,:is_searchable => true)
        FieldType.create(:type_name => 'Image Field',:use_image => true,:is_searchable => false)
       # FieldType.create(:type_name => 'Checkbox Field',:use_option => true)
      end

      desc "Run all bootstrapping tasks"
      task :all => [:field_type]
end