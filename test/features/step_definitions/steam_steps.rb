Then /^I should see a list of users$/ do
  # FIXME! implement webrat matchers
  response.body.join.should match(/id="users"/)
end

Then /^jquery should have set the document title to "([^\"]*)"$/ do |value|
  response.body.join.should match(/<title>\s*#{value}\s*<\/title>/)
end
