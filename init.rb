require 'redmine'

Redmine::Plugin.register :redmine_active_issues do
  name 'Redmine Active Issues plugin'
  author 'Evgeniy Shurmin'
  description 'This is a plugin add tab to each project to list active issues'
  version '0.0.1'
  permission :active_issues, { :active_issues => [:index] }, :public => true
  menu :project_menu, :active_issues, { :controller => 'active_issues', :action => 'index' }, :caption => 'active_issues', :after => :activity, :param => :project_id
end
