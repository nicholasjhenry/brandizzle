Factory.define(:brand) do |f|
  f.sequence(:name) {|i| "Brand#{i}" }
end

Factory.define(:search) do |f|
  f.sequence(:term) {|i| "bdd screencasts #{i}" }
end

Factory.define(:search_result) do |f|
  f.sequence(:body) {|i| "Result ##{i}" }
  f.source "twitter"
  f.sequence(:url) {|i| "http://www.twitter.com/status/234##{i}" }
end
