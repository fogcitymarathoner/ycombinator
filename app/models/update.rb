class Update < ActiveRecord::Base
       def date
       d = created_at
       d.to_s
       d.strftime("%B %d, %Y")
     end
end
