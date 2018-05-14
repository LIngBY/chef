name "web_server"
description "The base role for systems that installs JBoss Server and deploy wars"
run_list "recipe[web]"
env_run_lists "Chef-dev" => ["recipe[web]"], "_default" => ["recipe[web]"]
