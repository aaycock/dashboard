# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dashboard_session',
  :secret      => '4a7945971d3a36936a0be01867c67439de0bb498aa727fe35b97bec52e657c1adb087203064526703ede81c5b9e0e5dfcaca3255ff396be26760dfc704791351'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
