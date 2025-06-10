# app/services/alsaboor/agent_login_service.rb
module Alsaboor
  class AgentLoginService
    LOGIN_URL = "https://alsaboorportal.com/agent-login.php"

    def initialize(agent_code:, email:, password:)
      @agent_code = agent_code
      @email = email
      @password = password
      @agent = Mechanize.new
    end

    def login_agent
      page = @agent.get(LOGIN_URL)
      form = page.form_with(action: "/agent-login.php")

      return nil unless form

      form["ag_code"] = @agent_code
      form["csemail"] = @email
      form["cspass"] = @password

      form.submit # triggers login
      @agent # return logged-in agent
    end
  end
end
# Login service returns the logged-in agent
