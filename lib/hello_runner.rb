require './lib/hello_number'

alpha = HelloNumber.new # Initialize
alpha.parse!(ARGV) 
alpha.process # Process for word match
