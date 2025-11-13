###############################################################################
# TASK: generate_derivatives
#
# create small and thumb images for image and pdf files in the 'objects' folder
###############################################################################

require 'image_optim' unless Gem.win_platform?
require 'mini_magick'

def process_and_optimize_image(filename, file_type, output_filename, size, density)
  puts "DEBUG: Starting process for #{filename} -> #{output_filename}, type: #{file_type}" if ENV['DEBUG']
  
  # Initialize image_optim only once and only if not on Windows
  image_optim = nil
  unless Gem.win_platform?
    begin
      image_optim = ImageOptim.new(svgo: false)
      puts "DEBUG: ImageOptim initialized" if ENV['DEBUG']
    rescue StandardError => e
      puts "WARNING: Could not initialize ImageOptim: #{e.message}"
    end
  end
  
  if filename == output_filename && file_type == :image && image_optim
    puts "Optimizing: #{filename}"
    begin
      image_optim.optimize_image!(output_filename)
    rescue StandardError => e
      puts "Error optimizing #{filename}: #{e.message}"
    end
  elsif filename == output_filename && file_type == :pdf
    puts "Skipping: #{filename}"
  else
    puts "Creating: #{output_filename}"
    begin
      if file_type == :pdf
        # Use 'magick' for ImageMagick 7 compatibility - PDFs
        input_with_page = "#{filename}[0]"
        cmd = "magick -density #{density} \"#{input_with_page}\" -resize #{size} -flatten \"#{output_filename}\""
        puts "  Running PDF command: #{cmd}" if ENV['DEBUG']
        result = system(cmd)
        puts "  Command result: #{result}, exit status: #{$?.exitstatus}" if ENV['DEBUG']
        unless $?.success?
          raise "Magick command failed with status #{$?.exitstatus}"
        end
      else
        # For images, also use magick command to avoid MiniMagick API issues
        cmd = "magick \"#{filename}\" -resize #{size} -flatten \"#{output_filename}\""
        puts "  Running image command: #{cmd}" if ENV['DEBUG']
        result = system(cmd)
        puts "  Command result: #{result}, exit status: #{$?.exitstatus}" if ENV['DEBUG']
        unless $?.success?
          raise "Magick command failed with status #{$?.exitstatus}"
        end
      end
      
      # Optimize the output if image_optim is available
      if image_optim && File.exist?(output_filename)
        begin
          puts "  Optimizing output: #{output_filename}" if ENV['DEBUG']
          image_optim.optimize_image!(output_filename)
        rescue StandardError => e
          puts "  Warning: Could not optimize #{output_filename}: #{e.message}"
        end
      end
    rescue StandardError => e
      puts "Error creating #{output_filename} from #{filename}: #{e.message}"
      puts "  Error class: #{e.class}"
      puts "  Backtrace:"
      e.backtrace.first(10).each { |line| puts "    #{line}" }
    end
  end
end


desc 'Generate derivative image files from collection objects'
task :generate_derivatives, [:thumbs_size, :small_size, :density, :missing, :compress_originals, :input_dir] do |_t, args|
  # set default arguments
  # default image size is based on max pixel width they will appear in the base template features
  args.with_defaults(
    thumbs_size: '450x',
    small_size: '800x800',
    density: '300',
    missing: 'true',
    compress_originals: 'false',
    input_dir: 'objects'
  )

  # set the folder locations
  objects_dir = args.input_dir
  thumb_image_dir = objects_dir + '/thumbs'
  small_image_dir = objects_dir + '/small'

  # Ensure that the output directories exist.
  [objects_dir, thumb_image_dir, small_image_dir].each do |dir|
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
  end

  # support these file types
  EXTNAME_TYPE_MAP = {
    '.jpeg' => :image,
    '.jpg' => :image,
    '.pdf' => :pdf,
    '.png' => :image,
    '.tif' => :image,
    '.tiff' => :image
  }.freeze

  # CSV output
  list_name = File.join(objects_dir, 'object_list.csv')
  field_names = 'filename,object_location,image_small,image_thumb'.split(',')
  CSV.open(list_name, 'w') do |csv|
    csv << field_names

    # Iterate over all files in the objects directory.
    Dir.glob(File.join(objects_dir, '*')).each do |filename|
      # Skip subdirectories and the README.md file.
      if File.directory?(filename) || File.basename(filename) == 'README.md' || File.basename(filename) == 'object_list.csv'
        next
      end

      # Determine the file type and skip if unsupported.
      extname = File.extname(filename).downcase
      file_type = EXTNAME_TYPE_MAP[extname]
      unless file_type
        puts "Skipping file with unsupported extension: #{filename}"
        csv << ["#{File.basename(filename)}", "/#{filename}", nil, nil]
        next
      end

      # Get the lowercase filename without any leading path and extension.
      base_filename = File.basename(filename, '.*').downcase

      # Optimize the original image.
      if args.compress_originals == 'true'
        puts "Optimizing: #{filename}"
        process_and_optimize_image(filename, file_type, filename, nil, nil)
      end

      # Generate the thumb image.
      thumb_filename = File.join(thumb_image_dir, "#{base_filename}_th.jpg")
      if args.missing == 'false' || !File.exist?(thumb_filename)
        process_and_optimize_image(filename, file_type, thumb_filename, args.thumbs_size, args.density)
      else
        puts "Skipping: #{thumb_filename} already exists"
      end

      # Generate the small image.
      small_filename = File.join([small_image_dir, "#{base_filename}_sm.jpg"])
      if (args.missing == 'false') || !File.exist?(small_filename)
        process_and_optimize_image(filename, file_type, small_filename, args.small_size, args.density)
      else
        puts "Skipping: #{small_filename} already exists"
      end
      csv << ["#{File.basename(filename)}", "/#{filename}", "/#{small_filename}", "/#{thumb_filename}"]
    end
  end
  puts "\e[32mSee '#{list_name}' for list of objects and derivatives created.\e[0m"
end
