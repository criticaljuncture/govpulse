namespace :data do
  task :daily => %w(
    data:download:entries
    data:import:entries
    data:import:bulkdata
    data:download:full_text
    data:extract:agencies
    data:extract:places
    data:cache:update:all
    data:cache:expire
    data:extract:regulationsdotgov_id
    tmp:cache:clear
    thinking_sphinx:index
    sitemap:refresh
  )
  
  namespace :daily do 
    task :quick => %w(
    data:download:entries
    data:import:entries
    data:import:bulkdata
    data:download:full_text
    data:extract:agencies
    data:extract:places
    data:extract:regulationsdotgov_id
    )
  end
end