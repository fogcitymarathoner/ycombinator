ActionController::Routing::Routes.draw do |map|
  map.resources :updates

  map.resources :updates

  map.resources :messages
  map.resources :profiles
  map.resources :participants


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end


  map.resources :announcements
  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session
  map.resource :user_session_mc
  map.resources :participants, :member => { :delete => :get }
  map.resources :invitations

#  map.resources :registration, :controller => "users"

  map.index '/home_mc', :controller => "home_mc", :action => "index"
#  map.root :controller => "user_sessions", :action => "new"
  map.index '/loginfail', :controller => 'home', :action => 'login_retry'
  map.index '/home_forentrep', :controller => 'home', :action => 'home_forentrep'
  map.index '/home_access', :controller => 'home', :action => 'login_for_access'
  map.index '/home_forinvestors', :controller => 'home', :action => 'home_forinvestors'
  map.index '/learn_more', :controller => 'home', :action => 'home_learnmore'
  map.index '/blog', :controller => 'home', :action => 'blog'
  map.index '/faq_outside', :controller => 'home', :action => 'faq_outside'
  map.index '/project_setup', :controller =>'project', :action =>'project_setup'
  map.index '/project_setup_form_1', :controller =>'project', :action =>'project_setup_form_1'
  map.index '/project_setup_form_2', :controller =>'project', :action =>'project_setup_form_2'
  map.index '/project_setup_1a_form', :controller =>'project', :action =>'project_setup_1a_form'
  map.index '/project_participant', :controller =>'project', :action =>'project'
  map.index '/project_description', :controller =>'project', :action =>'project_description'
  map.index '/project_about', :controller =>'project', :action =>'project_about'
  map.index '/project_teaser', :controller =>'project', :action =>'project_teaser'
  map.index '/project_workspace', :controller =>'project', :action =>'project_workspace'
  map.index '/project_plan', :controller =>'project', :action =>'project_plan'
  map.index '/project_collaboration', :controller =>'project', :action =>'project_workspace'
  map.index '/project_participant_plan', :controller =>'project', :action =>'project'
  map.index '/project_participant_plan_key', :controller =>'project', :action =>'project_participant_plan_key'
  map.index '/project_participant_team', :controller =>'project', :action =>'project_participant_team'
  map.index '/project_participant_mentor', :controller =>'project', :action =>'project_participant_mentor'
  map.index '/project_public_inside', :controller =>'project', :action =>'project'
  map.index '/library', :controller =>'home', :action =>'library'

  map.index '/relatedresearch', :controller =>'research_item', :action =>'related'

  map.index '/savedialogue', :controller => 'dialogue', :action => 'save'


      map.index '/', :controller => 'home_mc', :action => 'index'

  map.index '/signup', :controller => 'registration', :action => 'new'
  map.index '/hubhome', :controller => 'hub', :action => 'hubhome'
  map.index '/hubhome_participation', :controller => 'hub', :action => 'hubhome_participation'
  map.index '/hubhome_watching', :controller => 'hub', :action => 'hubhome_watching'
  map.index '/watched_projects', :controller => 'hub', :action => 'watched_projects'
  map.index '/participating_projects', :controller => 'hub', :action => 'participating_projects'
  map.index '/myparticipation', :controller => 'hub', :action => 'myparticipation'
  map.index '/watch_this', :controller => 'project', :action => 'watch_this'
  map.index '/project_admin', :controller => 'project', :action => 'project_admin'
  map.index '/project_admin_plan', :controller => 'project', :action => 'project_admin_plan'
  map.index '/project_admin_plan_key', :controller => 'project', :action => 'project_admin_plan_key'
  map.index '/project_admin_team', :controller => 'project', :action => 'project_admin_team'
  map.index '/noproject', :controller => 'hub', :action => 'noproject'
  map.index '/myaccount', :controller => 'profiles', :action => 'myaccount'
  map.index '/edit_avatar', :controller => 'profiles', :action => 'edit_avatar'
  map.index '/public_profile', :controller => 'profiles', :action => 'public_profile'
  map.index '/myresearch', :controller => 'research_item', :action => 'myresearch'
  map.index '/project_research', :controller => 'project', :action => 'project_research'
  map.index '/createresearch', :controller => 'research_item', :action => 'createresearch'
  map.index '/announcements', :controller => 'announcements', :action => 'hub'
  map.index '/read', :controller => 'messages', :action => 'read'
  map.index '/inbox_list', :controller => 'messages', :action => 'inbox_list'
  map.index '/invite_list', :controller => 'messages', :action => 'invite_list'
  map.index '/load_modal_rss', :controller => 'simple_proxy', :action => 'load_modal_rss'


  map.index '/faq_inside', :controller => 'hub', :action => 'faq_inside'
  map.index '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.index '/login', :controller => 'user_session_mcs', :action => 'login'
  map.index '/user_session_mc/validate_login', :controller => 'user_session_mcs', :action => 'validate_login'
  map.index '/user_session_mc/validate_signup', :controller => 'user_session_mcs', :action => 'validate_signup'
  map.index '/user_session_mc/login', :controller => 'user_session_mcs', :action => 'login'
  map.index '/user_session_mc/signup', :controller => 'user_session_mcs', :action => 'signup'
  map.index '/login_for_access', :controller => 'user_sessions', :action => 'new_message'
  map.index '/project', :controller => 'project', :action => 'index'
  map.index '/terms', :controller => 'public', :action => 'terms'
  map.index '/privacy', :controller => 'public', :action => 'privacy'
  map.index '/public_projects', :controller => 'project', :action => 'public_projects'

  map.tag '/tags.js', :controller => 'tag', :action => 'index'
  map.tag '/searchtag', :controller => 'tag', :action => 'searchtag'
  map.tag '/tags.json', :controller => 'tag', :action => 'indexjson'


  map.index '/title.js',  :controller => 'search/index', :action => 'getTitle'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'



  # In routes.rb

end
