# Workaround: Locale relies on 'dl/win32', but in Ruby 1.9, this
# file is called 'Win32API'.
begin
  require 'dl/win32'
rescue LoadError
  begin
    require 'Win32API'
    $LOADED_FEATURES << 'dl/win32'
  rescue LoadError
    # We don't have either file, but that may be okay if we are not on Windows.
  end
end
require 'locale'
require 'yaml'

if Locale.current.language == 'de' then
  def t string
    string
  end
else
  LOCALIZATION_FILE = File.expand_path("#{__FILE__}/../en.yml")
  TRANSLATIONS = YAML.load_file(LOCALIZATION_FILE)
  
  def t string
    TRANSLATIONS[string] ||= begin
      @localization_file ||= (File.open(LOCALIZATION_FILE, 'a') rescue $stdout)
      @localization_file.puts "'#{string}': '#{string}' # TODO"
      string
    end
  end
end
