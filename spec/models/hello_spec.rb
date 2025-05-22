describe Hello do
  it 'says hello' do
    expect(Hello.new.greet).to eq('Hello, world!')
  end
end