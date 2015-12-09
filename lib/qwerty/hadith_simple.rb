require_relative 'text'
require_relative 'config'
module Qwerty
  class Text
    class HadithSimple < Ruote::Participant
   
     attr_accessor :hadith_content
     
     def initialize
       @collection  = Array.new      
       @hadith_content = Array.new 
       read_file 
     end

     def on_workitem
       workitem.fields['text']['hadith_simple'] = {
         :source => "http://tezkije.com",
         :book => "Sahih al-Bukhari",
         :num_char => num_char,
         :num_hadith => @hadith_content[:num],
         :english_tr => "",
         :albanian_tr =>  @hadith_content[:hadith],
         :chain_of_narration => @hadith_content[:narration],
       }
       workitem.fields['text']['content'] = hadith_content[:hadith]
       reply # work done, let flow resume
     end

     def read_file
         dir = Qwerty.configuration.hadith
         line = IO.readlines(dir)         
         line.each do |l|
           l.gsub!(/\n/, '')
           num, hadith = l.split(/\s\|\s/)
           hadith, narrator = hadith_transmitter(hadith)
           @collection << { num: num, hadith: hadith , narration: narrator} 
         end 
         generate_hadith          
     end
     
     def hadith_transmitter(hadith)
       /(?<hadith>.+)\.\((?<narrator>.+)\)/ =~ hadith
       return "#{hadith}","#{narrator}"
     end

     def generate_hadith
         @hadith_content = @collection.sample 
         @collection.delete_at(@hadith_content[:num].to_i - 1)                    
     end

     def num_char
         @hadith_content[:hadith].length
     end
   end
  end
end