namespace :bootstrap do
      desc "Add Field Types"
      task :field_type => :environment do
        FieldType.create(:type_name => 'Single Line Text Field')
        FieldType.create(:type_name => 'Multi Line Text Field')
        FieldType.create(:type_name => 'Select Field')
        FieldType.create(:type_name => 'Multi Select Field')
      end

      desc "Run all bootstrapping tasks"
      task :all => [:field_type]
end