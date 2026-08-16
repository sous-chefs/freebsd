# frozen_string_literal: true

name 'freebsd'

run_list 'freebsd::portsnap', 'test::default'

cookbook 'freebsd', path: '.'
cookbook 'test', path: './test/cookbooks/test'
