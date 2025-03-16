require 'csv'
require 'pdf-reader'

module Maintenance
  class PdfToCsvScoutingReportsTask < MaintenanceTasks::Task
    no_collection

    attribute :pdf_file_name, :string, default: 'keith-law-100.pdf'
    attribute :csv_file_name, :string, default: 'keith_law_scouting_reports.csv'

    def process
      # Set up paths
      pdf_path = Rails.root.join('db', 'sources', pdf_file_name)
      csv_path = Rails.root.join('db', 'sources', csv_file_name)

      unless File.exist?(pdf_path)
        Rails.logger.error("Error: PDF file not found at #{pdf_path}")
        return
      end

      Rails.logger.info("Starting conversion of #{pdf_file_name} to CSV format")

      # Extract text from PDF
      pdf_text = extract_text_from_pdf(pdf_path)

      # Parse the text into structured data
      scouting_reports = parse_scouting_reports(pdf_text)

      # Write to CSV
      write_to_csv(scouting_reports, csv_path)

      Rails.logger.info("Conversion completed. CSV file saved to #{csv_path}")
      Rails.logger.info("Total scouting reports processed: #{scouting_reports.size}")
    end

    private

    def extract_text_from_pdf(pdf_path)
      Rails.logger.info('Extracting text from PDF...')

      full_text = ''
      PDF::Reader.open(pdf_path) do |reader|
        reader.pages.each do |page|
          full_text += page.text
        end
      end

      Rails.logger.info("Text extraction complete. Extracted #{full_text.size} characters.")
      full_text
    end

    def parse_scouting_reports(text)
      Rails.logger.info('Parsing text into structured scouting reports...')

      reports = []

      # This regex pattern might need adjustment based on the actual format of the PDF
      # Looking for patterns like "1. Roman Anthony, OF, Red Sox"
      report_pattern = %r{(\d+)\.\s+([A-Za-z]+)\s+([A-Za-z-]+),\s+([A-Za-z/]+),\s+([A-Za-z\s]+)}

      # Split the text by numbered entries
      sections = text.split(/\d+\.\s+/).drop(1) # drop the first element which might be a header

      sections.each_with_index do |section, index|
        # The first line should contain the player info
        first_line = section.lines.first.strip

        # Try to extract structured data
        if match = first_line.match(%r{([A-Za-z]+)\s+([A-Za-z-]+),\s+([A-Za-z/]+),\s+(.+)})
          first_name = match[1]
          last_name = match[2]
          pos = match[3]
          team_full = match[4].strip

          # Convert team name to abbreviation
          team = convert_team_to_abbreviation(team_full)

          # The ranking is based on the position in the document
          overall_ranking = index + 1

          # The rest of the section is the scouting report body
          # Skip the first line which contains the player info
          body = section.lines.drop(1).join.strip

          reports << {
            first_name: first_name,
            last_name: last_name,
            pos: pos,
            team: team,
            overall_ranking: overall_ranking,
            body: body
          }

          Rails.logger.info("Parsed report for #{first_name} #{last_name}, rank: #{overall_ranking}")
        else
          Rails.logger.warn("Could not parse player info from: #{first_line}")
        end
      rescue StandardError => e
        Rails.logger.error("Error parsing section #{index + 1}: #{e.message}")
      end

      Rails.logger.info("Parsing complete. Found #{reports.size} scouting reports.")
      reports
    end

    def convert_team_to_abbreviation(team_name)
      # Map of team names to abbreviations
      team_abbreviations = {
        'Red Sox' => 'BOS',
        'Yankees' => 'NYY',
        'Blue Jays' => 'TOR',
        'Rays' => 'TB',
        'Orioles' => 'BAL',
        'Tigers' => 'DET',
        'Guardians' => 'CLE',
        'White Sox' => 'CWS',
        'Royals' => 'KC',
        'Twins' => 'MIN',
        'Astros' => 'HOU',
        'Angels' => 'LAA',
        'Athletics' => 'OAK',
        'Mariners' => 'SEA',
        'Rangers' => 'TEX',
        'Braves' => 'ATL',
        'Marlins' => 'MIA',
        'Mets' => 'NYM',
        'Phillies' => 'PHI',
        'Nationals' => 'WAS',
        'Cubs' => 'CHC',
        'Reds' => 'CIN',
        'Brewers' => 'MIL',
        'Pirates' => 'PIT',
        'Cardinals' => 'STL',
        'Diamondbacks' => 'ARI',
        'Rockies' => 'COL',
        'Dodgers' => 'LAD',
        'Padres' => 'SD',
        'Giants' => 'SF'
      }

      # Try to find the abbreviation, or return the original if not found
      team_abbreviations[team_name] || team_name
    end

    def write_to_csv(reports, csv_path)
      Rails.logger.info('Writing data to CSV file...')

      CSV.open(csv_path, 'w') do |csv|
        # Write headers
        csv << %w[first_name last_name pos team overall_ranking body]

        # Write data rows
        reports.each do |report|
          csv << [
            report[:first_name],
            report[:last_name],
            report[:pos],
            report[:team],
            report[:overall_ranking],
            report[:body]
          ]
        end
      end

      Rails.logger.info('CSV file created successfully.')
    end
  end
end
