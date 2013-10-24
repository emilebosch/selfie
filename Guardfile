guard 'shell' do
  watch(/(.*).txt/) {|m| `tail #{m[0]}` }
end