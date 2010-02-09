class Test::SessionsController < ApplicationController
  def index
    render :text => 'sessions'
  end

  def create
    reset_database!
    render :text => '123455', :status => 201 # TODO how to return the session id?
  end

  def destroy
    render :text => 'OK'
  end

  def reset_database!
    # request.env['rack.test.db_reset'] = 'dump' # TODO move to client

    case request.env['rack.test.db_reset']
    when 'dump'
      `mysql -u root env_test < #{Rails.root}/db/dumps/env_test.dump.sql`
    else
      ActiveRecord::Migration.suppress_messages do
        load("#{Rails.root}/db/schema.rb")
      end
      load("#{Rails.root}/test/fixtures.rb")
    end
  end
end