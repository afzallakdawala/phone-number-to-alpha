require './lib/hello_number'

describe HelloNumber do
  let(:phone) {"2255.63"}
  let(:file_path) {"/home/runner/dict3.txt"}
  before :each do
    @alpha = HelloNumber.new
    @alpha.phone = phone
    @alpha.file_path = file_path
  end

  it 'should have the expected true, Phone and Mobile number Validation' do
    expect(@alpha.is_valid?).to eql(true)
  end

  describe "Check for output" do
    let(:out) {@alpha.process}
    it 'should have output in upcase always' do
       expect(out).to eql(["CALL",'ME'])
    end
  end
 
end
