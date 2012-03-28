  $Price = 1000
  print <<EOF
The price is #{$Price}.
EOF

  print <<"EOF";			# same as above
The price is #{$Price}.
EOF

  print <<`EOC`			# execute commands
echo hi there
echo lo there
EOC

  print <<"foo", <<"bar"	# you can stack them
I said foo.
foo
I said bar.
bar

  def myfunc(strthis,num,strthat)
    puts strthis
    puts strthat * num
  end

  need_define_foo = true

  myfunc(<<"THIS", 5, <<'THAT')
Here's a line
or two.
THIS
and here's another.
THAT

  if need_define_foo
    eval <<-EOS			# delimiters can be indented
      def foo
    print "foo\n"
      end
    EOS
  end
