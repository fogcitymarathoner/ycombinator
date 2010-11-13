dropdb 3strides_development;
createdb -O postgres 3strides_development;
rake db:migrate
script/server
