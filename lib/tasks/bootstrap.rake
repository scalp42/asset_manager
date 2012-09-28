namespace :bootstrap do
      desc "Add Field Types"
      task :field_type => :environment do
        FieldType.create(:type_name => 'Single Line Text Field',:use_text => true,:is_searchable => true,:is_configurable => false)
        FieldType.create(:type_name => 'Multi Line Text Field', :use_text => true,:is_searchable => true,:is_configurable => false,:allows_wiki => true)
        FieldType.create(:type_name => 'IP Field',:use_ip => true,:is_searchable => true,:is_configurable => false)
        FieldType.create(:type_name => 'Select Field',:use_option => true,:is_searchable => true,:is_configurable => true)
        FieldType.create(:type_name => 'Multi Select Field',:use_option => true,:is_searchable => true,:is_configurable => true)
        FieldType.create(:type_name => 'Cascading Select Field',:use_casecade_option => true,:is_searchable => true,:is_configurable => true)
        FieldType.create(:type_name => 'Date Field',:use_date => true,:is_searchable => true,:is_configurable => false)
        FieldType.create(:type_name => 'Radio Field',:use_radio_option => true,:is_searchable => true,:is_configurable => true)
        FieldType.create(:type_name => 'Image Field',:use_image => true,:is_searchable => false,:is_configurable => false)
        FieldType.create(:type_name => 'Password Field',:use_password => true,:is_searchable => false,:is_configurable => false,:hashing_key => 'phMW1MGiF6Ov6wpUOsKpNe3wRi1pGoZrsmBvR30dvSiJj8HSLj3pOvR0')

        user = User.create(:email => 'admin@assetmanager.com' ,:password => 'assetmanager', :password_confirmation => 'assetmanager', :first_name => 'Admin', :last_name => '',:full_name => 'Admin',:active => true)

        group = Group.create(:name => 'all@assetmanager',:description => 'Default Group')
        group.membership.build(:user_id => user.id)

        group.save

      end

      desc "Reindex Assets"
      task :reindex => :environment do
        Tire.index('assets').delete

         Asset.import :per_page => 1000
      end

      desc "Add Cloud Vendor Types"
      task :cloud_vendor_types => :environment do
        CloudVendorType.create(:vendor_name => "Rackspace Cloud",:description => "")
        CloudVendorType.create(:vendor_name => "Amazon EC2 Cloud",:description => "")
      end

      desc "Run all bootstrapping tasks"
      task :all => [:field_type,:cloud_vendor_types,:reindex]
end