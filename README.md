# README
This app based on main idea of stackowerflow: people can ask questions and create answers for them. Created for lerning how some gems and technologies works.

### Ruby & Rails version
  - ruby 2.6.3
  - rails 5.2.3

### Features:

**Authentication**
  - gem 'devise'
  - gem 'omniauth'
  - gem 'omniauth-facebook'
  - gem 'omniauth-twitter'

**Authorization with Policies**
  - gem 'cancancan'

**App has REST API**
  - gem 'active_model_serializers'
  - gem 'doorkeeper'

**Background jobs (like email)**
  - gem 'sidekiq'
  - gem 'whenever'
  - ActiveJob

**Redis for sidekiq and caching**
  - Fragment caching (Russian doll caching)
  - gem 'redis-rails'

**Sphinx search**
  - gem 'thinking-sphinx'

**470 Rspec tests examples**
  - gem 'rspec-rails'
  - gem 'factory_girl_rails'
  - gem 'shoulda-matchers'

**Feature (acceptance) testing with JS**
  - gem 'capybara'
  - gem 'capybara-webkit'

**Views written on Slim & Bootstrap**
  - gem 'slim'
  - gem 'bootstrap-sass'

**PostgreSQL as main db**
  - gem 'pg'

**Ready to Deploy**
  - gem 'capistrano'

### Deployment instructions
  - cap production deploy
