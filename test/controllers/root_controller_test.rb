require 'test_helper'

class RootControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :ok
  end
  
  test "should list news" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&role=dapaas&tag=news").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('news-list.json'), :headers => {})
      
    get :news_list, :section => "news"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('#grid2 li').count, 1
    assert_equal doc.search('#grid2 li').first.search('h1')[0].content, "Test Dapaas content"
    assert_equal doc.search('#grid2 li').first.search('p.module-subheading')[0].content, "Alex Coley"
    assert_equal doc.search('#grid2 li').first.search('p.module-meta')[0].content, "9 December 2013"
    assert_equal doc.search('#grid2 li').first.search('p.category')[0].content, "news"
  end
  
  test "should display news" do
    stub_request(:get, "http://contentapi.dev/test-dapaas-content.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('test-dapaas-content.json'), :headers => {})
      
    get :news_article, :slug => "test-dapaas-content", :section => "news"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
      
    assert_equal doc.search('.page-title h1')[0].content, "Test Dapaas content"
    assert_equal doc.search('.article-body')[0].to_s.squish, "<article class=\"article-body\"> <p>Bacon ipsum dolor sit amet capicola corned beef turkey, brisket sirloin swine jowl. Turducken pig pork shoulder bacon turkey drumstick shank shankle. Kevin cow chicken beef ribs jowl turkey brisket drumstick salami biltong shoulder. Jerky turducken prosciutto tenderloin hamburger shankle.</p> <p>Frankfurter biltong pastrami meatloaf, tenderloin kielbasa brisket flank. Pork swine venison shoulder ham cow short ribs, salami ribeye turkey. Shoulder leberkas kevin flank, filet mignon andouille brisket ball tip chuck corned beef. Ham hock leberkas hamburger salami beef ribs, flank pancetta cow. Pork chop hamburger ribeye spare ribs, capicola bacon cow chicken pig.</p> <p>Short loin shankle rump shank shoulder ground round salami doner boudin. Brisket chuck filet mignon capicola flank tongue leberkas pig shankle, pancetta shank tenderloin meatball. Turducken rump short loin tongue boudin ribeye biltong doner chuck leberkas. Short loin turkey fatback salami sausage.</p> <p>Shank salami flank cow pork belly pork chop ham hock. Bresaola swine ham meatball, turducken doner salami. Tongue turducken hamburger, beef sausage short ribs fatback. Tongue pork belly pastrami tail filet mignon chicken ham turkey drumstick.</p> </article>".squish
  end
  
  test "should list events" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&role=dapaas&tag=event").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('events-list.json'), :headers => {})
      
    get :events_list, :section => "events"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('#grid2 li').count, 1
    assert_match /Dapaas test event/, doc.search('#grid2 li').first.search('h1.module-heading')[0].content
    assert_equal doc.search('#grid2 li').first.search('span.date')[0].to_s, "<span class=\"date\">Wednesday 25 December 2013<br>at  3:00PM</span>"
  end
  
  test "should display events" do
    stub_request(:get, "http://contentapi.dev/dapaas-test-event.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('dapaas-test-event.json'), :headers => {})
      
    get :events_article, :slug => "dapaas-test-event", :section => "events"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('.article-body h2')[0].content, "Dapaas test event"
    assert_equal doc.search('.article-body h3')[0].content, "Wednesday 25 December 2013,  3:00pm -  3:15pm"
    assert_match /<p>Bacon ipsum dolor sit amet hamburger fugiat jowl, reprehenderit filet mignon ut ad ham hock consectetur bresaola leberkas laborum pork drumstick. Incididunt ut laboris voluptate, velit aliquip dolor beef ribs strip steak short ribs. Beef meatloaf proident boudin nostrud. Jerky shank sed ullamco corned beef pork loin in.<\/p> <p>Ut turducken meatloaf pig mollit drumstick. Eiusmod andouille aute, pig turducken magna bacon cupidatat cow shank in prosciutto cillum hamburger esse. Ea jowl consequat drumstick adipisicing. Labore biltong ball tip eiusmod tempor, velit sed jerky ribeye cillum consectetur est sausage.<\/p> <p>Ham do id shank brisket corned beef. Veniam short loin consectetur, qui laborum hamburger consequat ea sausage ham hock venison brisket shankle minim nisi. Cow kevin non, pork loin sausage ham hock sint pork tri-tip officia est commodo consectetur occaecat enim. Quis dolore spare ribs biltong, rump andouille nisi jerky pancetta tri-tip chicken venison ullamco boudin. Beef tenderloin leberkas mollit excepteur officia anim.<\/p> <p>Anim pancetta ut salami labore nulla qui hamburger filet mignon chicken exercitation. Chicken tri-tip tempor enim. Ullamco chuck cupidatat pork loin, nulla ham boudin pastrami sint sirloin irure tempor minim. Ullamco exercitation id flank. Deserunt pancetta ball tip cupidatat kevin venison. Kielbasa sirloin adipisicing sunt hamburger spare ribs turducken pork.<\/p>/, doc.search('.article-body')[0].to_s.squish
  end
  
  test "should display pages" do
    stub_request(:get, "http://contentapi.dev/test-dapaas-content.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('dapaas-test-page.json'), :headers => {})
      
    get :page, :slug => "test-dapaas-content"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('.page-title h1')[0].content, "Dapaas test page"
    assert_equal doc.search('.article-body')[0].to_s.squish, "<article class=\"article-body\"> <p>Bacon ipsum dolor sit amet venison bacon pastrami, swine frankfurter rump filet mignon tri-tip beef ribs sirloin shankle sausage. Short loin ribeye pork corned beef capicola leberkas swine. Chuck ball tip shoulder frankfurter hamburger swine. Drumstick cow pastrami strip steak capicola meatball chicken swine ball tip doner. Shankle doner capicola meatball. Brisket drumstick capicola, jerky spare ribs andouille bacon short ribs tri-tip ball tip sirloin.</p> </article>".squish
  end

end