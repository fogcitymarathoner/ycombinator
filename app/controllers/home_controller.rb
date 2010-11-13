class HomeController < ApplicationController
     before_filter :current_profile

  
   def index
     @title = "Micro Venture Capital"
   end

   def login_for_access
     @title = "Micro Venture Capital"
   end
   
   def home_forentrep
     @title = "For Entrepreneurs"
   end
  
   def blog
     @title = "Blog"
   end
  
   def home_learnmore
     @title = "Learn More"
   end
 
   def home_forinvestors
     @title = "For Investors"
   end
  
end
