module Dome
  class Environment
    attr_reader :environment, :account, :settings

    def initialize(directories = Dir.pwd.split('/'))
      @environment = directories[-1]
      @account     = directories[-2]
      @settings    = Dome::Settings.new
      ENV['AWS_PROFILE'] = @account
      ENV['AWS_DEFAULT_REGION'] = 'eu-west-1'
    end

    def team
      @settings.parse['project']
    end

    def accounts
      %W(#{team}-dev #{team}-prd)
    end

    def environments
      @settings.parse['environments']
    end

    def valid_account?(account_name)
      puts "Account: #{account_name.colorize(:green)}"
      accounts.include? account_name
    end

    def valid_environment?(environment_name)
      puts "Environment: #{environment_name.colorize(:green)}"
      environments.include? environment_name
    end

    def invalid_account_message
      puts "\n'#{@account}' is not a valid account.\n".colorize(:red)
      generic_error_message
      exit 1
    end

    def invalid_environment_message
      puts "\n'#{@environment}' is not a valid environment.\n".colorize(:red)
      generic_error_message
      exit 1
    end

    private

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def generic_error_message
      puts "The 'account' and 'environment' variables are assigned based on your current directory.\n".colorize(:red)
      puts "The expected directory structure is '.../<account>/<environment>'\n".colorize(:red)
      puts '============================================================================='
      puts "Valid environments are defined using the 'environments' key in your itv.yaml."
      puts "The environments you have defined are: #{environments}."
      puts '============================================================================='
      puts 'Valid accounts are of the format <project>-dev/prd and <project>-prd' \
           " (where 'project' is defined using the 'project' key in your itv.yaml."
      puts "The accounts you have defined are: #{accounts}."
      puts '============================================================================='
      puts 'To fix your issue, try the following:'
      puts '1. Set your .aws/config to one of the valid accounts above.'
      puts '2. Ensure you are running this from the correct directory.'
      puts '3. Update your itv.yaml with the required environments or project.'
    end
  end
end
