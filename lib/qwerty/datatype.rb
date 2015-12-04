require "ruote"
require_relative "quran_simple"

module Qwerty 
 class Text
  class QuranSimple  
     class Datatype < Ruote::Participant
       attr_accessor :collection, :row, :random_num

       def on_workitem
         @language = workitem.fields['text']['quran_simple']['languageList']
         workitem.fields['text']['quran_simple'].merge!(ayah)
         reply
       end 
       
       def ayah
           text = Hash.new
           @language.each_key { |key| text = execute(@language[key]['dir'], key) }
           return text
       end

       def execute(dir, key)
           coll_key = "@collection_#{key}"
           instance_variable_set(coll_key, Array.new) unless instance_variable_defined?(coll_key)
           @collection = instance_variable_get("@collection_#{key}") 
           read_file(dir) if @collection.empty?
           random_generate(key)
       end

       def read_file(file_name)
           File.read(file_name).each_line do |line|
             line.gsub!(/\n/, '')
             surah, ayah, verse = line.split(/\|/)
             @collection << { surah: surah, ayah: ayah, verse: verse}
           end
       end

       def random_generate(key)
           @random_num = rand(collection.size) if row == nil
           @row = collection[random_num]
           (@verse ||= Hash.new).merge!({ key => row[:verse] })
           row[:verse] = @verse
           collection.delete_at(random_num)
           return row
       end
     end
   end
 end
end