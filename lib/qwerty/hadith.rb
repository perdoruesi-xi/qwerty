require_relative 'text'
module Qwerty
  class Text
    class Hadith < Ruote::Participant
   
   attr_accessor :hadith_content, :delete_hadith
   
   def initialize
     @collection  = Array.new      
     @hadith_content = Array.new 
     read_file(source_file)
   end

   def on_workitem
     workitem.fields['text']['hadith_simple'] = {
       :source => "http://tezkije.com (15KB)",
       :book => "Sahih al-Bukhari",
       :num_char => num_char,
       :num_hadith => @hadith_content[:num],
       :english_tr => "",
       :albanian_tr =>  @hadith_content[:hadith],
       :chain_of_narration => @hadith_content[:narration],
       # :delete_hadith => @delete_hadith
     }
     reply # work done, let flow resume
   end

   def read_file(file)
       line = IO.readlines(file)         
       line.each do |l|
         l.gsub!(/\n/, '')
         num, hadith = l.split(/\s\|\s/)
         hadith, chain = narration(hadith)
         @collection << { num: num, hadith: hadith , narration: chain} 
       end 
       generate_hadith          
   end
   
   def narration(hadith)
     /(.+)\.\((.+)\)/ =~ hadith
     return "#$1","#$2"
   end

   def source_file
     "./lib/qwerty/lng_trsl/hadithfile"
   end

   def generate_hadith
       @hadith_content = @collection.sample 
       # control_hadith
       delete_hadith                   
   end


   def control_hadith      
   end

   def num_char
       @hadith_content[:hadith].length
   end

   def delete_hadith
       @collection.delete_at(@hadith_content[:num].to_i - 1) 
       # File.open("./lib/qwerty/deletehadith", 'a') do |file|
       #     file.write @hadith_content[:hadith] 
       #     file.write("\n")
       # end
   end    

 end
  end
end