module Maintenance
  class SeedTrackingListsTask < MaintenanceTasks::Task
    no_collection

    def process
      # Initialize counters
      lists_created = 0
      links_created = 0

      Rails.logger.info('Starting to seed tracking lists...')

      # Find user by email
      user = User.find_by(email: 'wrburgess@gmail.com')

      if user.nil?
        Rails.logger.error('User with email wrburgess@gmail.com not found!')
        return
      end

      Rails.logger.info("Found user: #{user.email} (ID: #{user.id})")

      # Create tracking lists if they don't exist
      lists = [
        {
          name: 'Trade Targets',
          notes: 'Players to target in trade discussions with other managers',
          icon_name_on: 'bi-star-fill',
          icon_name_off: 'bi-star'
        },
        {
          name: 'Prospect Watch List',
          notes: 'Top prospects to monitor for potential call-ups and future value',
          icon_name_on: 'bi-binoculars-fill',
          icon_name_off: 'bi-binoculars'
        },
        {
          name: 'Recently Hyped',
          notes: 'Players gaining attention and hype in recent weeks',
          icon_name_on: 'bi-megaphone-fill',
          icon_name_off: 'bi-megaphone'
        }
      ]

      # Clear existing tracking lists for this user (optional)
      user.tracking_lists.destroy_all
      Rails.logger.info('Cleared existing tracking lists for user')

      # Create tracking lists
      tracking_lists = []
      lists.each do |list_data|
        list = TrackingList.find_or_create_by(name: list_data[:name], user: user, icon_name_on: list_data[:icon_name_on], icon_name_off: list_data[:icon_name_off]) do |l|
          l.notes = list_data[:notes]
        end

        next unless list.persisted?

        tracking_lists << list
        lists_created += 1
        Rails.logger.info("Created/found tracking list: #{list.name} (ID: #{list.id})")
      end

      # Add random players to each list
      tracking_lists.each do |list|
        # Clear existing players from the list
        list.players.clear
        Rails.logger.info("Cleared existing players from list: #{list.name}")

        # Get random number of players between 10-15
        num_players = rand(10..15)

        # Get all player IDs
        all_player_ids = Player.pluck(:id)

        # Choose random subset
        random_player_ids = all_player_ids.sample(num_players)

        # Add players to list
        random_player_ids.each do |player_id|
          player = Player.find(player_id)
          unless list.players.include?(player)
            list.players << player
            links_created += 1
            Rails.logger.info("Added player #{player.name} (ID: #{player_id}) to list #{list.name}")
          end
        rescue ActiveRecord::RecordNotFound
          Rails.logger.error("Player with ID #{player_id} not found")
        end

        Rails.logger.info("Added #{list.players.count} players to list: #{list.name}")
      end

      # Report summary
      Rails.logger.info('Tracking lists seeding completed:')
      Rails.logger.info("  Lists created/found: #{lists_created}")
      Rails.logger.info("  Player links created: #{links_created}")

      # List details of each tracking list
      tracking_lists.each do |list|
        Rails.logger.info("\nList: #{list.name} (#{list.players.count} players)")
        list.players.each_with_index do |player, idx|
          Rails.logger.info("  #{idx + 1}. #{player.name} (#{player.position}, #{player.level})")
        end
      end
    end
  end
end
