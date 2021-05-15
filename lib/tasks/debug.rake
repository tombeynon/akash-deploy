namespace :debug do
  task zombie_lease: :environment do
    password = ENV['KEYRING_PASS'].presence || raise('Please provide KEYRING_PASS')
    akash = Akash::Client.new(password)
    zombies = []
    akash.deployments.closed.each do |deploy|
      next if ENV['MIN_DSEQ'] && deploy.dseq.to_i < ENV['MIN_DSEQ'].to_i
      next if ENV['MAX_DSEQ'] && deploy.dseq.to_i > ENV['MAX_DSEQ'].to_i

      zombie_leases = deploy.leases.all.find_all do |l|
        l.services.any?
      rescue
        false
      end
      next unless zombie_leases.any?
      zombies << {
        dseq: deploy.dseq,
        providers: zombie_leases.map(&:provider)
      }
    end
    if zombies.any?
      puts "Zombie lease found"
      zombies.each do |deploy|
        puts "Deployment: #{deploy[:dseq]}"
        deploy[:providers].each do |provider|
          puts "Lease: #{provider}"
        end
      end
    end
  end
end
