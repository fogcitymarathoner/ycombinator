class Profile < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :small => "150x150>", :thumb => "80x80>" }

  composed_of :display_name,
              :class_name => 'Display_name',
              :mapping =>
                [ # database      ruby
                %w[ firstname     first ],
                %w[ middleinitial initials ],
                %w[ lastname      last ]
                ]
                
   composed_of :display_name_short,
              :class_name => 'Display_name_short',
              :mapping =>
                [ # database      ruby
                %w[ firstname     first ],
                %w[ lastname      last ]
                ]

  has_one :user
  has_many :participants
  has_many :projects, :through => :participants
  has_one  :owned_project, :through => :participants, :source => :project,
              :conditions => "participants.role = 'team_leader'"
  has_many :watched_project, :through=> :participants, :source => :project,
              :conditions => "participants.role = 'watcher'"
  has_many :participant_project, :through=> :participants, :source => :project,
              :conditions => "participants.role = 'participant'"
  # mini-profile
 
  def location
   
  end
 
  def name_with
    @city = city
    @state = state
    location =[ @city,", ", @state ].join(" ") 
      if location.nil?
                ""
                else
                location
                end
    display_name.to_s+
    '</div><div class="tooltip"><div class="miniprofile_container">'+
    '<div class="mp_image"><img src="'+avatar.to_s+'"width="60" height="60"></div>'+
    '<div class="mp_name">'+display_name.to_s+'</div>'+
    '<div class="mp_score"><img src="/images/score_bg.png"></div>'+
    '<div class="mp_location">'+location+'</div>'+
    '<div class="mp_title">'+headline.to_s+'</div>'+
    '<div class="mp_badges"><img src="/images/'+team_leader_badge+'"></div>'+
    '<div class="mp_vp"><a class="profile_modal" href="/public_profile?id='+id.to_s+'">[view profile]</a></div>'+
    '<div class="mp_message"><a href="/messages/new?id='+id.to_s+'">[send message]</a></div>'+
    '<div class="mp_bottom"></div>'+
    '</div>'
  end

  def name_with_left
   '<div class="display_name_left">'+
    display_name.to_s+
    '</div><div class="tooltip"><div class="miniprofile_container">'+
    '<div class="mp_image"><img src="/images/profile_blank_image.png" width="60" height="60"></div>'+
    '<div class="mp_name">'+display_name.to_s+'</div>'+
    '<div class="mp_score"><img src="/images/score_bg.png" width="80" height="85"></div>'+
    '<div class="mp_title">'+'Title'+'</div>'+
    '<div class="mp_location">'+'location'+'</div>'+
    '<div class="mp_headline">Headline Goes Here</div>'+
    '<div class="mp_vp">[view profile]</div>'+
    '<div class="mp_message">[send message]</div>'+
    '<div class="mp_bottom"></div>'+
    '</div></div>'

  end
     
  def team_leader_badge
    if owned_project.nil?
      ""
    else
      'team_leader_badge_80.png'
    end
  end

end
 
class Display_name
  attr_reader :first, :initials, :last
  
  def initialize(first, initials, last)
    @first = first.capitalize
    @initials = initials.upcase
    @last = last.capitalize
  end
  
   def to_s
    if initials.empty?
    [ @first, @last ].compact.join(" ")  
    else
    [ @first, @initials+".", @last ].compact.join(" ")
    end
  end
end

class Display_name_short
  def initialize(first, last)
    @first = first
    @last = last
  end
  
  def to_s
    [ @first, @last ].compact.join(" ")
  end
end




