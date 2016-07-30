namespace :parking_lot do
  desc 'Process file input.'
  task :process_file_input, [:file_input] => :environment do |t, args|
    include TranslationHelper
    puts "Processing file : " + args[:file_input]

    begin
      open_file = open(args[:file_input])
      parking_space = nil
      open_file.each do |line|
        command_hash = TranslationHelper.translate_command(line)
        parking_space = run_command(parking_space, command_hash)
      end
    rescue Exception => e
      puts "Exiting. Reason: " + e.to_s
    end
  end

  desc 'Interactive Parking Space Console.'
  task interactive_console: :environment do
    include TranslationHelper

    parking_space = nil    
    while true
      begin
        command = gets.chomp
        command_hash = TranslationHelper.translate_command(command)
        parking_space = run_command(parking_space, command_hash)
      rescue Exception => e
        puts "Exiting. Reason : " + e.to_s
      end
    end
  end

  def run_command(parking_space, hash)
    if hash[:method] == "create_parking_lot"
      parking_space = ParkingSpace.send(hash[:method], hash[:args][0])
    elsif parking_space.present?
      parking_space.send(hash[:method], *hash[:args])
    else
      puts ParkingSpace::ReturnStrings::INITIALIZATION_ERROR
    end
    parking_space
  end
end


