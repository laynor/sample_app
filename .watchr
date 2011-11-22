ENV["WATCHR"] = "1"
system 'clear'



def growl(message)
  pass_img = "https://lh6.googleusercontent.com/-Pg3Ng4Y8gfA/TrfsSDR6DWI/AAAAAAAABG8/RZiV7M6Grdw/s64/passed.png"
  fail_img = "https://lh4.googleusercontent.com/-ZaIb_-DPCIs/TrfsRv0KWSI/AAAAAAAABG4/ki5u8O6w4TU/s64/failed.png"
  growlnotify = `which gntp-send`.chomp
  title = "Watchr Test Results"
  puts message
  image = message.match(/\s0\s(errors|failures)/) ? pass_img : fail_img
  options = "-a Watchr -p 123 '#{title}'  '#{message}' '#{image}'"
  system %(#{growlnotify} #{options} &)
end

def notify(message)
  if message.match(/\s0\s(errors|failures)/)
    msg_and_face = [" PASS ", "font-lock-keyword-face"]
  else
    msg_and_face = [" FAIL ", "font-lock-constant-face"]
  end
  cmd = "emacsclient -e \"(enotify-railstest-send \\\" #{msg_and_face[0]} \\\" '#{msg_and_face[1]})\""
  puts "$ " +  cmd
  system(cmd)
end

    

def run(cmd)
  puts(cmd)
  `#{cmd}`
end

def run_spec_file(file)
  system('clear')
  result = run(%Q(rspec #{file}))
  notify result.split("\n").last rescue nil
  puts result
end

def run_all_specs
  system('clear')
  result = run "rspec spec/"
  notify result.split("\n").last rescue nil
  puts result
end

def run_all_features
  system('clear')
  system("cucumber")
end

def related_spec_files(path)
  Dir['spec/**/*.rb'].select { |file| file =~ /#{File.basename(path).split(".").first}_spec.rb/ }
end

def run_suite
  tl = Time.now.localtime
  puts " --- Running suite <#{tl.day}/#{tl.month}/#{tl.year} #{tl.hour}:#{tl.min}:#{tl.sec}> ---\n\n"
  run_all_specs
  run_all_features
end

watch('spec/spec_helper\.rb') {
  tl = Time.now.localtime
  puts " --- Running suite <#{tl.day}/#{tl.month}/#{tl.year} #{tl.hour}:#{tl.min}:#{tl.sec}> ---\n\n"
  run_all_specs
}
watch('spec/.*/.*_spec\.rb') {
  |m|
  tl = Time.now.localtime
  puts " --- Running suite <#{tl.day}/#{tl.month}/#{tl.year} #{tl.hour}:#{tl.min}:#{tl.sec}> ---\n\n"
  run_spec_file(m[0])
}
watch('app/.*/.*\.rb') {
  |m|
  related_spec_files(m[0]).map {|tf| run_spec_file(tf) }
}
watch('app/.*/.*\.erb') {
  run_all_specs
}

watch('features/.*/.*\.feature') { run_all_features }

tl = Time.now.localtime
puts " --- Initial Run <#{tl.day}/#{tl.month}/#{tl.year} #{tl.hour}:#{tl.min}:#{tl.sec}> --- "
run_all_specs

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all specs <#{tl.day}/#{tl.month}/#{tl.year} #{tl.hour}:#{tl.min}:#{tl.sec}> ---\n\n"
  run_all_specs
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end
