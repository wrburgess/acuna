class FlatFileImporterService
  attr_reader :file, :klass, :required_columns, :import_mode

  def initialize(file:, controller_class:, required_columns: [], import_mode: ImportModes::CREATE)
    @file = file
    @klass = controller_class
    @required_columns = required_columns
    @import_mode = import_mode
  end

  def import
    raise 'No file provided' if file.nil?

    case File.extname(file.original_filename)
    when '.csv' then process_file(file_type: 'csv')
    when '.xls', '.xlsx' then process_file(file_type: 'excel')
    else
      raise "Unknown file type - #{file.original_filename}"
    end
  end

  private

  def process_file(file_type: 'csv')
    rows = []
    batch_size = 1000 # Adjust the batch size as needed

    if file_type == 'csv'
      spreadsheet = Roo::CSV.new(file.path)
    elsif file_type == 'excel'
      spreadsheet = Roo::Spreadsheet.open(file.path)
    end

    headers = spreadsheet.row(1)
    validate_headers(headers)

    ActiveRecord::Base.transaction do
      klass.delete_all if import_mode == ImportModes::REPLACE

      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        rows << row

        if rows.size >= batch_size
          process_rows(rows)
          rows.clear
        end
      end

      # Process any remaining rows after the loop
      process_rows(rows) if rows.any?
    end
  end

  def validate_headers(headers)
    missing_columns = required_columns - headers if required_columns.any?

    raise "Missing required columns - #{missing_columns.join(', ')}" if missing_columns.any?

    true
  end

  def process_rows(rows)
    case import_mode
    when ImportModes::CREATE, ImportModes::REPLACE
      klass.insert_all!(rows)
    when ImportModes::UPDATE
      rows.each do |row|
        record = klass.find(row['id'])
        record.update!(row)
      end
    end
  end
end
