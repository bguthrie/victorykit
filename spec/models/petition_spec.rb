require 'spec_helper'

describe Petition do
  describe "validation" do
    subject { build(:petition) }
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :owner_id }
    its(:title) { should_not start_or_end_with_whitespace }
  end
  
  it "should find all emailable petitions not yet known to a member" do
    member = create(:member)
    
    signed_petition = create(:petition)
    create(:signature, petition: signed_petition, member: member)

    previously_sent_petition = create(:petition)
    create(:sent_email, petition: previously_sent_petition, member: member)

    new_emailable_petition = create(:petition, to_send: true)
    new_unemailable_petition = create(:petition, to_send: false)
    
    interesting_petitions = Petition.find_interesting_petitions_for(member)
    interesting_petitions.should eq [new_emailable_petition]
  end

  it "should return its experiments" do
    petition = create(:petition)
    petition.experiments.should_not be_nil
  end

  context "facebook descrption" do
    it "should escape single and double quotes because wysihtml5 doesn't" do
      petition = create(:petition, description: "'\"this description contains quotes")
      petition.facebook_description_for_sharing.should == "&apos;&quot;this description contains quotes"
    end

    it "should strip tags" do
      petition = create(:petition, description: "this description contains a <a href=\"http://woo.com\">link</a>")
      petition.facebook_description_for_sharing.should == "this description contains a link"
    end
  end
end
