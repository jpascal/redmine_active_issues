require 'redmine'

Redmine::Plugin.register :redmine_active_issues do
  name 'Redmine Active Issues plugin'
  author 'Evgeniy Shurmin'
  description 'This is a plugin add tab to each project to list active issues'
  version '0.0.2'
  url 'https://github.com/jpascal/redmine_active_issues'
  author_url 'https://github.com/jpascal'
  settings :default => {
      "status_ids" => []
  }, :partial => 'settings/activeissues_settings'
  project_module :active_issues do
    permission :active_issues, {:active_issues => :index}
  end
  menu :project_menu, :active_issues, { :controller => 'active_issues', :action => 'index' }, :caption => :plugin_active_issues, :after => :activity, :param => :project_id
end
