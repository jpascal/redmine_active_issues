class ActiveIssuesController < ApplicationController
  unloadable

  before_filter :find_project, :authorize

  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper

  def index
    @query = Query.new(:name => "_")
    @query.project = @project
    @query.group_by = "tracker"
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update({'id' => "#{Issue.table_name}.id"}.merge(@query.available_columns.inject({}) {|h, c| h[c.name.to_s] = c.sortable; h}))
    @issue_count = @query.issue_count
    @issue_pages = Paginator.new self, @issue_count, per_page_option, params['page']
    @issues = @query.issues(:include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
                            :order => sort_clause,
                            :offset => @issue_pages.current.offset,
                            :limit => per_page_option,
                            :conditions => ["start_date <= ? and status_id in (?)", Time.now, (Setting.plugin_redmine_active_issues['status_ids'] || []).collect {|i| i.to_i}])
    @issue_count_by_group = @query.issue_count_by_group
    render 'index', :layout => !request.xhr?
  end

private

  def find_project
    @project = Project.find_by_identifier(params[:project_id])
    unless @project.present?
      render_404
    end
  end
end
