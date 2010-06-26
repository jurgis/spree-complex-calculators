namespace :spree do
  namespace :extensions do
    namespace :complex_calculators do
      
      desc "Copies public assets of the Complex Calculators to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[ComplexCalculatorsExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(ComplexCalculatorsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
      
      desc "Manage extension migrations"
      task :migrate => :environment do
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
            version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
            
            ActiveRecord::Migrator.migrate("#{ComplexCalculatorsExtension.root}/db/migrate/", version)
            Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end
    end
  end
end