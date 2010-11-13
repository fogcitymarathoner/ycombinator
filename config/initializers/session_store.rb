# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_3strides_session',
  :secret      => 'e94dec8db1c5f7e9cfee0f5ce5a5ea98e36b0d5a6d5aed367a8a91fe8ef4e7c7d4fdc8fd739b6f46c498f795eea2887f0f83b398949017e650ea251453d39216'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
