namespace :cover_me do
  
  task :report do
    require 'cover_me'
    CoverMe.complete!
  end

 task :all => %w{ rake:spec rake:cucumber report }
 task :spec => %w{ rake:spec report }
 task :cucumber => %w{ rake:cucumber report } 
end
